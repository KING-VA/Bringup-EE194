package kalman.mem

import chisel3._
import chisel3.util._
import freechips.rocketchip.config._
import freechips.rocketchip.rocket._
import kalman.utils.LossyBuffer

class L1Controller()(implicit p: Parameters) extends Module {
  val io = IO(new Bundle {
    val req = Flipped(Decoupled(new L1Request))
    val resp = Decoupled(new L1Response)

    // TODO: These are magic numbers that come in the cmd. What do they mean?
    val dprv = Input(UInt(PRV.SZ.W))
    val dv = Input(Bool())

    val mem = new HellaCacheIO
  })

  // configure memory interface (don't care about s1/s2)
  io.mem.s1_data.mask := Cat(Fill(io.mem.coreDataBits, 1.U(1.W))) // no mask
  io.mem.s1_data.data := 0.U
  io.mem.s1_kill := false.B
  io.mem.s2_kill := false.B
  io.mem.keep_clock_enabled := true.B

  // take input, send req to L1
  io.mem.req <> io.req.map { req =>
    val mem_req = Wire(new HellaCacheReq())

    mem_req.no_alloc := false.B // write-allocate so things stay in cache
    mem_req.mask := req.mask
    mem_req.size := 3.U
    mem_req.no_xcpt := false.B
    mem_req.phys := false.B
    mem_req.signed := false.B
    mem_req.dv := io.dv
    mem_req.dprv := io.dprv

    // HellaCache chops off the top two bits of your tag between when it
    // receives a request and returns a response. SimpleHellaCacheIF takes
    // your request, stores the whole tag, sends your request to HellaCache,
    // and then unsets the “inflight” bit when it receives a response from
    // HellaCache with the same tag. So if you don’t chop off the top two bits
    // yourself, it’ll stall forever because the response tag doesn’t match.
    mem_req.tag := Cat(0.U(2.W), req.addr(4,0))
    // TODO: support masked write (M_PWR)
    mem_req.cmd := Mux(req.write, M_XWR, M_XRD)
    mem_req.addr := req.addr(io.mem.coreMaxAddrBits - 1, 0)
    mem_req.data := req.data

    mem_req
  }

  // Use a buffer to latch the memory output, if needed.
  val buf = LossyBuffer(io.mem.resp)

  // Send the output of the buffer out the receiving end when its ready.
  io.resp <> buf.map { mem_resp =>
    val l1_resp = Wire(new L1Response)
    l1_resp.data := mem_resp.data
    l1_resp.addr := mem_resp.addr
    l1_resp
  }
}
