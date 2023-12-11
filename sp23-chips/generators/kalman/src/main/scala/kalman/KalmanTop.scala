package kalman

import chisel3._
import chisel3.util._
import freechips.rocketchip.config._
import freechips.rocketchip.rocket.HellaCacheIO
import freechips.rocketchip.tile._
import kalman.mem.L1Controller
import kalman.vec.{VectorConfig, VectorUnit, VectorUnitPacket}

/**
 * The actual logic for the Kalman filter. It is initialized by
 * KalmanAcceleratorImp.
 *
 * @param p
 */
class KalmanTop()(implicit p: Parameters) extends Module {
  val io = IO(new Bundle {
    val cmd = Flipped(Decoupled(new RoCCCommand))
    val resp = Decoupled(new RoCCResponse)
    val mem = new HellaCacheIO
    val busy = Output(Bool())
  })

  // Config
  implicit val config = VectorConfig(32, 8, 4)

  // State Registers
  val cmd = RegInit(0.U.asTypeOf(new RoCCCommand))
  val busy = RegInit(false.B)

  // L1 Control Unit
  val l1Unit = Module(new L1Controller())
  l1Unit.io.mem <> io.mem
  l1Unit.io.dv := cmd.status.dv
  l1Unit.io.dprv := cmd.status.dprv

  // Vector Unit
  val itemSize = 16
  val numItems = 16
  val numVectors = 4
  val vectorUnit = Module(new VectorUnit())
  l1Unit.io.req <> vectorUnit.io.mem_in
  vectorUnit.io.mem_out <> l1Unit.io.resp

  // Status Outputs
  io.cmd.ready := !busy
  io.busy := busy

  // Send Requests to the Vector Unit
  val (op, opw) = KalmanOp.safe(io.cmd.bits.inst.funct(KalmanOp.getWidth - 1, 0))
  when(io.cmd.fire) {
    assert(opw)
    busy := true.B
    cmd := io.cmd.bits
  }
  vectorUnit.io.req <> io.cmd.map { new_cmd =>
    val x = Wire(new VectorUnitPacket())
    x.addr := new_cmd.rs2
    x.v0 := new_cmd.rs1
    x.v1 := new_cmd.rs2
    x.op := op
    x
  }

  // Send Responses through the RoCC Interface
  val vectorUnitResponseQueue = Queue(vectorUnit.io.resp, entries = 1)
  when(vectorUnitResponseQueue.fire) {
    busy := false.B
  }
  io.resp <> vectorUnitResponseQueue.map { resp =>
    val x = Wire(new RoCCResponse())
    x.data := resp.asUInt
    x.rd := cmd.inst.rd
    x
  }
}
