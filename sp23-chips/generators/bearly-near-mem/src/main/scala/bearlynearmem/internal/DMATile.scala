package bearlynearmem.internal

import bearlynearmem.{Mode, NearMemDMA}
import chipsalliance.rocketchip.config.Parameters
import chisel3._
import chisel3.util.{Queue, log2Ceil}
import freechips.rocketchip.diplomacy.{IdRange, LazyModule, LazyModuleImp}
import freechips.rocketchip.tilelink.{TLBundle, TLChannelBeatBytes, TLClientNode, TLEdgeOut, TLMasterParameters, TLMasterPortParameters, TLOutwardNode, TLWidthWidget}

private[bearlynearmem] class DMATile(config: NearMemDMA.Config)(implicit p: Parameters) extends LazyModule {
  private[internal] val masterNodeInt = TLClientNode(Seq(
    TLMasterPortParameters.v2(
      masters = Seq(
        TLMasterParameters.v2(name = "near-mem-dma-read", sourceId = IdRange(0, 1)),
      ),
      channelBytes = TLChannelBeatBytes(config.opSize)
    ),
    TLMasterPortParameters.v2(
      masters = Seq(
        TLMasterParameters.v2(name = "near-mem-dma-write", sourceId = IdRange(0, 1))
      ),
      channelBytes = TLChannelBeatBytes(config.opSize)
    )
  ))

  val masterNode: TLOutwardNode = TLWidthWidget(config.opSize) :=* masterNodeInt

  override lazy val module = new DMATileImp(this, config)

  lazy val regIO = module.regIO
}

private[internal] class DMATileImp(self: DMATile, config: NearMemDMA.Config) extends LazyModuleImp(self) {
  require(self.masterNodeInt.portParams.forall(_.channelBytes.a.get == config.opSize), "channel widths are incorrect")

  self.masterNodeInt.out.foreach { case (bundle, _) =>
    val dWidth = bundle.d.bits.data.getWidth
    require(dWidth == config.opSize * 8, {
      s"wrong d width: expected ${config.opSize * 8}, got $dWidth"
    })
    val aWidth = bundle.a.bits.data.getWidth
    require(aWidth == config.opSize * 8, {
      s"wrong a width: expected ${config.opSize * 8}, got $aWidth"
    })
  }

  private val Seq(readMaster, writeMaster) = self.masterNodeInt.out

  val impl = Module(new DMATileInner(
    config,
    readEdge = readMaster._2,
    writeEdge = writeMaster._2,
  ))

  impl.io.readPort <> readMaster._1
  impl.io.writePort <> writeMaster._1

  val regIO = IO(chiselTypeOf(impl.regIO))
  regIO <> impl.regIO
}

private[internal] class DMATileInner(config: NearMemDMA.Config, readEdge: TLEdgeOut, writeEdge: TLEdgeOut) extends Module {
  private val srcAddrReg = new RegisterRW(0.U(config.addressSize.W), "srcAddr")
  private val srcAddr = srcAddrReg.reg
  private val srcStrideReg = new RegisterRW((config.opSize).U(config.addressSize.W), "srcStride")
  private val srcStride = srcStrideReg.reg
  private val destAddrReg = new RegisterRW(0.U(config.addressSize.W), "destAddr")
  private val destAddr = destAddrReg.reg
  private val countReg = new RegisterRW(0.U(32.W), "count")
  private val count = countReg.reg

  private val modeRawReg = new RegisterRW(0.U(Mode.getWidth.W), "modeRaw")
  private val modeRaw = modeRawReg.reg
  private val (mode, modeValid) = Mode.safe(modeRaw)

  private val operandRegisterRawReg = Seq.tabulate(config.opSize / config.ctrlBeatBytes) { i =>
    new RegisterRW(0.U((config.ctrlBeatBytes * 8).W), s"operandRegisterRaw$i")
  }
  private val operandRegisterRaw = VecInit(operandRegisterRawReg.map(_.reg))
  private val operandRegister = operandRegisterRaw.asUInt
  assert(operandRegister.getWidth == config.opSize * 8)

  private val operandAsSInt8 = utils.chop(operandRegister, 8).map(_.asSInt)

  private val destRegAsSInt16 = RegInit(VecInit.fill(config.opSize / 2) {
    0.S((2 * 8).W)
  })
  private val destinationRegister = destRegAsSInt16.asUInt
  assert(destinationRegister.getWidth == config.opSize * 8)

  // TODO: redesign for more parallelism
  private val isReqInFlight = RegInit(false.B)

  class ErrorsBundle extends Bundle {
    val badMode = Bool()
    val srcMisaligned = Bool()
    val dstMisaligned = Bool()
    val strideMisaligned = Bool()
    val countTooLarge = Bool()
    val readDenied = Bool()
    val readCorrupt = Bool()
    val writeDenied = Bool()
  }

  class StatusBundle extends Bundle {
    val error = Bool()
    val completed = Bool()
    val inProgress = Bool()
    val errors = new ErrorsBundle()
  }

  private val status = Wire(new StatusBundle)

  status.error := status.errors.asUInt.orR
  status.errors := 0.U.asTypeOf(status.errors)
  status.completed := false.B
  status.inProgress := false.B

  private val destinationRegisterView = utils.chop(destinationRegister, 8 * config.ctrlBeatBytes)

  val regIO = IO(new Bundle {
    val status = Output(new StatusBundle)
    val modeRaw = modeRawReg.io
    val srcAddr = srcAddrReg.io
    val srcStride = srcStrideReg.io
    val destAddr = destAddrReg.io
    val count = countReg.io
    val operandRegister = Vec(operandRegisterRawReg.length, operandRegisterRawReg.head.io)
    val destinationRegister = Output(chiselTypeOf(destinationRegisterView))
  })

  regIO.status := status
  modeRawReg.connect(regIO.modeRaw)
  srcAddrReg.connect(regIO.srcAddr)
  srcStrideReg.connect(regIO.srcStride)
  destAddrReg.connect(regIO.destAddr)
  countReg.connect(regIO.count)
  (regIO.operandRegister zip operandRegisterRawReg).foreach { case (io, reg) =>
    reg.connect(io)
  }
  regIO.destinationRegister := destinationRegisterView

  val io = IO(new Bundle {
    val readPort = TLBundle(readEdge.bundle)
    val writePort = TLBundle(writeEdge.bundle)
  })

  Seq(io.readPort, io.writePort).foreach { port =>
    port.a.noenq()
    port.c.noenq()
    port.e.noenq()
    port.b.nodeq()
    port.d.nodeq()
  }


  // Bus error registers
  private val readDenied = RegInit(false.B)
  private val readCorrupt = RegInit(false.B)
  private val writeDenied = RegInit(false.B)
  // Note: currently the error only appears one cycle later, since these are registers

  status.errors.readDenied := readDenied
  status.errors.readCorrupt := readCorrupt
  status.errors.writeDenied := writeDenied

  when(regIO.count.write.fire) {
    readDenied := false.B
    readCorrupt := false.B
    writeDenied := false.B
  }


  status.errors.badMode := !modeValid

  // Alignment checks
  private def isOpAligned(value: UInt): Bool = !(value & (config.opSize - 1).U).orR

  private def validateDestAddr(): Unit = {
    status.errors.dstMisaligned := !isOpAligned(destAddr)
  }
  // Source addr + stride always used
  status.errors.srcMisaligned := !isOpAligned(srcAddr)
  status.errors.strideMisaligned := !isOpAligned(srcStride)

  status.completed := !status.inProgress
  status.inProgress := (count =/= 0.U && !status.error) || isReqInFlight

  io.readPort.a.noenq()
  when(count > 0.U && !isReqInFlight && !status.error) {
    io.readPort.a.enq(
      readEdge.Get(0.U, srcAddr, log2Ceil(config.opSize).U)._2
    )
    when(io.readPort.a.fire) {
      count := count - 1.U
      srcAddr := srcAddr + srcStride

      isReqInFlight := true.B
    }
  }

  // FIXME: ensure response is valid!
  private val readQueue = Module(new Queue(chiselTypeOf(io.readPort.d.bits.data), 2))
  readQueue.io.enq.noenq()
  io.readPort.d.ready := readQueue.io.enq.ready
  when(io.readPort.d.valid) {
    // we want to ack the message without inserting into the queue (dropping it)
    // upon error
    when(io.readPort.d.bits.denied) {
      readDenied := true.B
    }.elsewhen(io.readPort.d.bits.corrupt) {
      readCorrupt := true.B
    }.otherwise {
      // it's ok, put it in the queue
      readQueue.io.enq <> io.readPort.d.map(_.data)
    }
  }

  private val readOut = readQueue.io.deq
  readOut.nodeq()

  private val macIndex = RegInit(0.U(32.W))
  when(mode === Mode.copy) {
    validateDestAddr()

    io.writePort.a <> readOut.map(writeEdge.Put(0.U, destAddr, log2Ceil(config.opSize).U, _)._2)
    when(io.writePort.a.fire) {
      destAddr := destAddr + srcStride
    }

    io.writePort.d.deq()
    when(io.writePort.d.fire) {
      val writeResp = io.writePort.d.bits
      isReqInFlight := false.B
      when(writeResp.denied) {
        writeDenied := true.B
      }
    }
  }.elsewhen(mode === Mode.mac) {
    // size check
    status.errors.countTooLarge := count > (config.opSize / 2).U

    def saturate(v: SInt): SInt = {
      utils.saturate(v, 16)
    }

    val op1 = operandAsSInt8
    val resultDecoupled = readOut.map { op2Raw =>
      val op2 = utils.chop(op2Raw, 8).map(_.asSInt)

      //printf(f"MAC Op1: ${op1.map { _ => "%x" }.mkString(" ")}\n", op1: _*)
      //printf(f"MAC Op2: ${op2.map { _ => "%x" }.mkString(" ")}\n", op2: _*)
      val multiplied = VecInit((op1 zip op2).map { case (a, b) => a * b })
      //printf(f"MAC Multiplied: ${multiplied.map { _ => "%x" }.mkString(" ")}\n", multiplied: _*)
      val result = saturate(multiplied.reduceTree(_ +& _))
      //printf(cf"MAC ResultInside: $result\n")
      result
    }

    resultDecoupled.ready := true.B
    when(resultDecoupled.fire) {
      //printf(cf"MAC Result ${resultDecoupled.bits}\n")
      destRegAsSInt16(macIndex) := resultDecoupled.deq()
      macIndex := macIndex + 1.U

      isReqInFlight := false.B
    }

    when(status.completed) {
      macIndex := 0.U
    }
  }
}
