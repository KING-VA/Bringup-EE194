package kalman.vec

import chisel3._
import chisel3.experimental.ChiselEnum
import chisel3.util._
import hardfloat.{AddRecFN, fNFromRecFN}
import kalman.KalmanOp
import kalman.mem.{L1Request, L1Response}
import org.scalacheck.Prop.False


object VectorUnitState extends ChiselEnum {
  val idle = Value
  val loading = Value
  val storing = Value
  val dotting = Value
  val multiplying = Value
  val adding = Value
  val dividing = Value
  val respond = Value
}

/**
 * VectorUnit does operations on vectors and matrices. For vectors, it can
 * return in a single cycle. For matrices (unimplemented) it may take many
 * cycles.
 */
class VectorUnit()(implicit c: VectorConfig) extends Module {
  val io = IO(new Bundle {
    val req = Flipped(Decoupled(new VectorUnitPacket))
    val resp = Decoupled(Vec(c.numItems, Bits(c.itemSize.W)))

    val mem_in = Decoupled(new L1Request)
    val mem_out = Flipped(Decoupled(new L1Response))
  })

  // By default, don't do anything.
  io.req.nodeq()
  io.resp.noenq()
  io.mem_in.noenq()
  io.mem_out.nodeq()

  // Make sure request bits are stable...
  val req = Reg(new VectorUnitPacket)
  val resp = Reg(Vec(c.numItems, UInt(c.itemSize.W)))

  // State
  val state = RegInit(VectorUnitState.idle)
  val vout = RegInit(0.U(log2Ceil(c.numVectors + 1).W))
  val size = RegInit(c.numItems.U(log2Ceil(c.numItems + 1).W))
  val iter_size = RegInit(c.numItems.U(log2Ceil(c.numItems + 1).W))
  val notSent = RegInit(true.B)

  // 4 vector registers, each has numItems of itemSize
  val registers = RegInit(VecInit.tabulate(c.numVectors) { _ =>
    VecInit.tabulate(c.numItems) { _ =>
      0.U(c.encodedItemSize.W)
    }
  })
  val tmpRegister = RegInit(VecInit.tabulate(c.numItems) { _ =>
    0.U(c.encodedItemSize.W)
  })

  // Multiplier shared between dot product and elementwise mul
  val multiplier = Module(new VectorMultiplier)
  multiplier.io.in := DontCare
  val divider = Module(new VectorDivider)
  divider.io := DontCare
  divider.io.in.valid := false.B
  divider.io.out.ready := false.B

  val dpAccum = fNFromRecFN(c.expWidth, c.sigWidth, tmpRegister.reduceTree { (in0, in1) =>
    val adder = Module(new AddRecFN(c.expWidth, c.sigWidth))
    adder.io.a := in0
    adder.io.b := in1
    adder.io.roundingMode := hardfloat.consts.round_max
    adder.io.subOp := false.B
    adder.io.detectTininess := false.B
    RegNext(adder.io.out)
  }).asTypeOf(resp)
  val numCycles = RegInit(log2Ceil(c.numItems).U)

  switch(state) {
    is(VectorUnitState.idle) {
      io.req.ready := true.B
      when(io.req.valid) {
        req := io.req.bits
        iter_size := size
        notSent := true.B
        switch(io.req.bits.op) {
          is(KalmanOp.ld_vector) {
            state := VectorUnitState.loading
            for (i <- 0 until c.numItems) {
              registers(io.req.bits.v0)(i.U) := 0.U.asTypeOf(registers(io.req.bits.v0)(0))
            }
          }
          is(KalmanOp.st_vector) {
            state := VectorUnitState.storing
          }
          is(KalmanOp.dot_vector) {
            state := VectorUnitState.dotting
          }
          is(KalmanOp.v_add, KalmanOp.v_sub) {
            state := VectorUnitState.adding
          }
          is(KalmanOp.v_mul) {
            state := VectorUnitState.multiplying
          }
          is(KalmanOp.v_div, KalmanOp.v_sqrt) {
            state := VectorUnitState.dividing
          }
          is(KalmanOp.v_fill) {
            for (i <- 0 until c.numItems) {
              registers(io.req.bits.v0)(i.U) := io.req.bits.v1
            }
            state := VectorUnitState.respond
          }
          is(KalmanOp.v_set_out) {
            vout := io.req.bits.v0
            state := VectorUnitState.respond
          }
          is(KalmanOp.v_set_size) {
            size := io.req.bits.v0
          }
        }
      }
    }

    is(VectorUnitState.loading) {
      io.mem_out.ready := true.B
      when(notSent) {
        val l1req = Wire(new L1Request)
        l1req.addr := req.addr
        l1req.mask := DontCare
        l1req.data := DontCare
        l1req.write := false.B
        io.mem_in.enq(l1req)
      }
      when(io.mem_in.fire) {
        notSent := false.B
      }
      when(io.mem_out.fire) {
        for (x <- 0 until c.itemsPerWord) {
          registers(req.v0)((c.numItems + x).U - iter_size) :=
            c.encode(io.mem_out.bits.data((c.itemsPerWord - x) * c.itemSize - 1, (c.itemsPerWord - x - 1) * c.itemSize))
        }
        req.addr := req.addr + 8.U
        notSent := true.B
        when(iter_size <= c.itemsPerWord.U) {
          resp := 0.U.asTypeOf(Vec(c.numItems, UInt(c.itemSize.W)))
          state := VectorUnitState.respond
        }
        iter_size := iter_size - c.itemsPerWord.U
      }
    }

    is(VectorUnitState.storing) {
      io.mem_out.ready := true.B
      when(notSent) {
        val l1req = Wire(new L1Request)
        l1req.addr := req.addr
        l1req.mask := Mux(
          iter_size < c.itemsPerWord.U,
          0xFF.U << ((c.itemsPerWord.U - iter_size) << (8 / c.itemsPerWord).U),
          0xFF.U
        )
        var acc = c.decode(registers(req.v0)(c.numItems.U - iter_size))
        for (x <- 1 until c.itemsPerWord) {
          acc = Cat(acc, c.decode(registers(req.v0)((c.numItems + x).U - iter_size)))
        }
        l1req.data := acc
        l1req.write := true.B
        io.mem_in.enq(l1req)
      }
      when(io.mem_in.fire) {
        notSent := false.B
      }
      when(io.mem_out.fire) {
        req.addr := req.addr + 8.U
        notSent := true.B
        // when we hit the last iteration
        when(iter_size <= c.itemsPerWord.U) {
          resp := 0.U.asTypeOf(Vec(c.numItems, UInt(c.itemSize.W)))
          state := VectorUnitState.respond
        }
        iter_size := iter_size - c.itemsPerWord.U
      }
    }

    is(VectorUnitState.dotting) {
      when(notSent) {
        tmpRegister := multiplier.multiply(registers(req.v0), registers(req.v1))
        numCycles := log2Ceil(c.numItems).U
      }
      notSent := false.B
      when(!notSent) {
        numCycles := numCycles - 1.U
        when (numCycles === 0.U) {
          resp := dpAccum
          state := VectorUnitState.respond
          numCycles := log2Ceil(c.numItems).U
        }
      }
    }

    is(VectorUnitState.multiplying) {
      registers(vout) := multiplier.multiply(registers(req.v0), registers(req.v1))
      state := VectorUnitState.respond
      resp := 0.U.asTypeOf(resp)
    }

    is(VectorUnitState.dividing) {
      divider.io.in.bits.sqrt := req.op === KalmanOp.v_sqrt
      divider.io.in.bits.inputs(0) := registers(req.v0)
      divider.io.in.bits.inputs(1) := registers(req.v1)
      divider.io.in.valid := true.B
      divider.io.out.ready := true.B
      when(divider.io.in.ready) {
        notSent := false.B
      }
      when(!notSent) {
        divider.io.in.valid := false.B
      }
      when(divider.io.out.fire) {
        registers(vout) := divider.io.out.bits
        state := VectorUnitState.respond
        resp := 0.U.asTypeOf(resp)
      }
    }

    is(VectorUnitState.adding) {
      (registers(req.v0) lazyZip registers(req.v1) lazyZip registers(vout)).foreach((a, b, o) => {
        val adder = Module(new AddRecFN(c.expWidth, c.sigWidth))
        adder.io.a := a
        adder.io.b := b
        adder.io.roundingMode := hardfloat.consts.round_max
        adder.io.subOp := KalmanOp.v_sub === req.op
        adder.io.detectTininess := false.B
        o := adder.io.out
      })
      resp := 0.U.asTypeOf(resp)
      state := VectorUnitState.respond
    }

    is(VectorUnitState.respond) {
      io.resp.enq(resp)
      when(io.resp.fire) {
        state := VectorUnitState.idle
      }
    }
  }
}
