package prefetchers

import chisel3._
import chisel3.util._
import chisel3.experimental.{IO}
import freechips.rocketchip.config.{Field, Parameters, Config}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.util._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.subsystem._
import freechips.rocketchip.regmapper.{HasRegMap, RegField}

case class TLPrefetcherParams(
  address: BigInt = 0x10050000,
  prefetchIds: Int = 4,
  prefetcher: String => Option[CanInstantiatePrefetcher] = _ => None
)

case object TLPrefetcherKey extends Field[TLPrefetcherParams](TLPrefetcherParams())

class TLPrefetcher(implicit p: Parameters) extends LazyModule {
  val params = p(TLPrefetcherKey)

  def mapInputIds(masters: Seq[TLMasterParameters]) = TLXbar.assignRanges(masters.map(_.sourceId.size + params.prefetchIds))

  val node = TLAdapterNode(
    clientFn = { cp =>
      cp.v1copy(clients = (mapInputIds(cp.clients) zip cp.clients).map { case (range, c) => c.v1copy(
        sourceId = range
      )})
    },
    managerFn = { mp => mp }
  )

  // Handle size = 1 gracefully (Chisel3 empty range is broken)
  def trim(id: UInt, size: Int): UInt = if (size <= 1) 0.U else id(log2Ceil(size)-1, 0)

  lazy val module = new LazyModuleImp(this) {
    (node.in zip node.out) foreach { case ((in, edgeIn), (out, edgeOut)) =>
      val nClients = edgeOut.master.clients.size
      val outIdMap = edgeOut.master.clients.map(_.sourceId)
      val inIdMap = edgeIn.master.clients.map(_.sourceId)

      val snoop = Wire(Valid(new Snoop))
      val snoop_client = Wire(UInt(log2Ceil(nClients).W))

      val enable_prefetcher = RegInit(true.B)

      // Implement prefetchers per client.
      val prefetchers = edgeOut.master.clients.zipWithIndex.map { case (c,i) =>
        val pParams = params.prefetcher(c.name).getOrElse(NullPrefetcherParams())
        println(s"Prefetcher for ${c.name}: ${pParams.desc}")
        val prefetcher = pParams.instantiate()
        prefetcher.io.snoop.valid := snoop.valid && snoop_client === i.U
        prefetcher.io.snoop.bits := snoop.bits
        prefetcher.io.pc.pc_0 := 0.U
        prefetcher.io.pc.pc_1 := 0.U
        prefetcher.io.pc.pc_valid_0 := false.B
        prefetcher.io.pc.pc_valid_1 := false.B
        prefetcher.io.pc.branch_taken_0 := false.B
        prefetcher.io.pc.branch_taken_1 := false.B
        prefetcher.io.flush := false.B
        prefetcher
      }

      val out_arb = Module(new RRArbiter(new Prefetch, nClients))
      out_arb.io.in <> prefetchers.map(_.io.request)

      val tracker = RegInit(0.U(params.prefetchIds.W))
      val next_tracker = PriorityEncoder(~tracker)
      val tracker_free = !tracker(next_tracker)

      def inIdAdjuster(source: UInt) = Mux1H((inIdMap zip outIdMap).map { case (i,o) =>
        i.contains(source) -> (o.start.U | (source - i.start.U))
      })
      def outIdAdjuster(source: UInt) = Mux1H((inIdMap zip outIdMap).map { case (i,o) =>
        o.contains(source) -> (trim(source - o.start.U, i.size) + i.start.U)
      })
      def outIdToPrefetchId(source: UInt) = Mux1H((inIdMap zip outIdMap).map { case (i,o) =>
        o.contains(source) -> trim(source - (o.start + i.size).U, params.prefetchIds)
      })
      def prefetchIdToOutId(source: UInt, client: UInt) = Mux1H((inIdMap zip outIdMap).zipWithIndex.map { case ((i,o),id) =>
        (id.U === client) -> ((o.start + i.size).U +& source)
      })
      def inIdToClientId(source: UInt) = Mux1H(inIdMap.zipWithIndex.map { case (i,id) =>
        i.contains(source) -> id.U
      })

      out <> in
      out.a.bits.source := inIdAdjuster(in.a.bits.source)
      in.b.bits.source := outIdAdjuster(out.b.bits.source)
      out.c.bits.source := inIdAdjuster(in.c.bits.source)
      val d_is_prefetch = out.d.bits.opcode === TLMessages.HintAck
      in.d.valid := out.d.valid && !d_is_prefetch
      when (d_is_prefetch) { out.d.ready := true.B }
      in.d.bits.source := outIdAdjuster(out.d.bits.source)

      tracker := (tracker
        ^ ((out.d.valid && d_is_prefetch) << outIdToPrefetchId(out.d.bits.source))
        ^ ((out.a.fire() && !in.a.valid) << next_tracker)
      )
      snoop.valid := in.a.fire() && edgeIn.manager.supportsAcquireBFast(in.a.bits.address, log2Ceil(p(CacheBlockBytes)).U)
      snoop.bits.address := in.a.bits.address
      val acq = in.a.bits.opcode.isOneOf(TLMessages.AcquireBlock, TLMessages.AcquirePerm)
      val toT = in.a.bits.param.isOneOf(TLPermissions.NtoT, TLPermissions.BtoT)
      val put = edgeIn.hasData(in.a.bits)
      snoop.bits.write := put || (acq && toT)
      snoop_client := inIdToClientId(in.a.bits.source)

      //MMIO Chicken Bit
      when(in.a.valid && in.a.bits.address === params.address.U && put) {
        enable_prefetcher := in.a.bits.data(0)
      }

      val legal_address = edgeOut.manager.findSafe(out_arb.io.out.bits.block_address).reduce(_||_)
      val (legal, hint) = edgeOut.Hint(
        prefetchIdToOutId(next_tracker, out_arb.io.chosen),
        out_arb.io.out.bits.block_address,
        log2Up(p(CacheBlockBytes)).U,
        Mux(out_arb.io.out.bits.write, TLHints.PREFETCH_WRITE, TLHints.PREFETCH_READ)
      )
      out_arb.io.out.ready := false.B
      when (!in.a.valid) {
        out.a.valid := out_arb.io.out.valid && tracker_free && legal && legal_address && enable_prefetcher
        out.a.bits := hint
        out_arb.io.out.ready := out.a.ready
      }
      when (!legal || !legal_address) {
        out_arb.io.out.ready := true.B
      }
    }
  }
}

object TLPrefetcher {
  def apply()(implicit p: Parameters) = {
    val prefetcher = LazyModule(new TLPrefetcher)
    prefetcher.node
  }
}

case class TilePrefetchingMasterPortParams(hartId: Int, base: TilePortParamsLike) extends TilePortParamsLike {
  val where = base.where
  def injectNode(context: Attachable)(implicit p: Parameters): TLNode = {
    TLPrefetcher() :*=* base.injectNode(context)(p)
  }
}

case class PrefetcherMMIOParams(
  address: BigInt = 0x10050000
)

case object PrefetcherMMIOKey extends Field[Option[PrefetcherMMIOParams]](None)

trait PrefetcherMMIOIO extends Bundle

trait PrefetcherMMIOModule extends HasRegMap {
  implicit val p: Parameters
  def params: PrefetcherMMIOParams

  val prefetcher_enable = Reg(Bool())
  regmap(
  0x00 -> Seq(
    RegField.w(1, prefetcher_enable))
  )
}

class PrefetcherMMIO(params: PrefetcherMMIOParams, beatBytes: Int)(implicit p: Parameters)
  extends TLRegisterRouter(
    params.address, "prefetcher", Seq("ucbbar,prefetcher"),
    beatBytes = beatBytes)(
      new TLRegBundle(params, _) with PrefetcherMMIOIO)(
      new TLRegModule(params, _, _) with PrefetcherMMIOModule)

trait CanHavePeripheryPrefetcher { this: BaseSubsystem =>
  private val portName = "prefetcher"

  val prefetcher_mmio = p(PrefetcherMMIOKey) match {
    case Some(params) => {
      val prefetcher_mmio = LazyModule(new PrefetcherMMIO(params, pbus.beatBytes)(p))
      pbus.toVariableWidthSlave(Some(portName)) { prefetcher_mmio.node }
      Some(prefetcher_mmio)
    }
    case None => None
  }
}

trait CanHavePeripheryPrefetcherModuleImp extends LazyModuleImp {
  val outer: CanHavePeripheryPrefetcher
}

class WithPrefetcherMMIO() extends Config((site, here, up) => {
  case PrefetcherMMIOKey => Some(PrefetcherMMIOParams())
})

