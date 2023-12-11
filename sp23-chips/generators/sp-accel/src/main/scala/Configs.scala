package spaccel

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._


class WithSparseAccel extends Config((site, here, up) => {
   case BuildRoCC => up(BuildRoCC) ++ Seq((p: Parameters) => {
      val spaccel = LazyModule(new SparseAccel()(p))
      spaccel
   })
})
