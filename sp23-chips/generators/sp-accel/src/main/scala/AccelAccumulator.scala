package spaccel

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import chisel3.experimental.IntParam
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._

class AccelAccumulatorPipe0Bundle extends Bundle {
  val weight = SInt(8.W)
  val start = Bool()
  val last = Bool()
}

class AccelAccumulator()(implicit p: Parameters) extends Module {

//FSM


  val io = IO(new Bundle {
    val sparse_decoder = Flipped(Decoupled(new SparseDecoderAccumulatorInterface))
    val accumulator_mem_controller = Decoupled(new AccumulatorMemControllerInterface)
    val mem_controller_accumulator = Flipped(Decoupled(new MemControllerAccumulatorInterface))
    val cmd = Flipped(Decoupled(new AccumulatorCmd()))
    val busy = Output(Bool())
  })

  val dense_row_size = RegInit(0.U(8.W))
  val dense_row_size_valid = RegInit(false.B)
  io.accumulator_mem_controller.bits := DontCare

  io.cmd.ready := true.B

  when(io.cmd.ready && io.cmd.valid)
  {
    dense_row_size := io.cmd.bits.dense_row_size
    dense_row_size_valid := true.B
  }

  // State machine states
  // init sparse_valid_word_0 word_1 ... word_n-1 write_back_0 write_back_1 .... write_back_n-1
  val sparse_valid = RegInit(false.B)
  val word_counter = RegInit(0.U(8.W))
  val writeback_counter = RegInit(0.U(8.W))

  val sparse = RegInit(0.S.asTypeOf(new AccelAccumulatorPipe0Bundle()))
  val acc_reg = RegInit(0.S.asTypeOf(Vec(16, Vec(8, SInt(17.W)))))
  val dense_row_vec = WireInit(VecInit(Seq.fill(8) {0.S(8.W)}))

  val intr_mul_result = WireInit(VecInit(Seq.fill(8) {0.S(17.W)}))
  val intr_acc_wire = WireInit(VecInit(Seq.fill(8) {0.S(17.W)}))
  val intr_acc_result = WireInit(VecInit(Seq.fill(8) {0.S(17.W)}))

  

  // val acc_reg_width = WireInit(8.U)
  
  dense_row_vec := io.mem_controller_accumulator.bits.dense_row_data.asTypeOf(dense_row_vec)
  for (i <- 0 until 8) {

    intr_mul_result(i) := 0.S
    intr_mul_result(i) := dense_row_vec(i) * sparse.weight
    // when (intr_mul_result < (2.U << acc_reg_width)) {
    //   vec_mul_wire(i) := intr_mul_result(7,0);
    // }
    // .otherwise {
    //   vec_mul_wire(i) := (2.U << acc_reg_width) - 1.U
    // }
  }
  io.busy := sparse_valid

  // TODO: If we were to pipeline, logic would be s_init || s_word_n-1 and not last || last and write_back_n-1
  io.sparse_decoder.ready := !sparse_valid
  when (io.sparse_decoder.fire) {
    sparse_valid := true.B
    sparse.weight := io.sparse_decoder.bits.weight.asTypeOf(SInt(8.W))
    sparse.start := io.sparse_decoder.bits.startRowWeight
    sparse.last :=  io.sparse_decoder.bits.endRowWeight
  }

  // this means that after I have sparse data, then I can fetch the dense data. 
  // dense_row_size means cols of rows / 8 because 8 dense elements are the number of dense rows
  // that can be sent in the same cycle. 

  // I found a bug here. If sparse row only contains 64 bits of data (i.e. 4 weight-index pairs), then 
  // acc_reg will not 
  io.mem_controller_accumulator.ready := sparse_valid && word_counter <= (dense_row_size - 1.U)
  
  val data_word_index = Wire(UInt(8.W))
  data_word_index := io.mem_controller_accumulator.bits.data_index

  when(io.mem_controller_accumulator.fire) {
    for (i <- 0 until 8) {
      when(sparse.start) {
        intr_acc_wire(i) := 0.S
      }
      .otherwise {
        intr_acc_wire(i) := acc_reg(io.mem_controller_accumulator.bits.data_index)(i)
      }

      intr_acc_result(i) := intr_mul_result(i) + intr_acc_wire(i)

      when(sparse.last){
        when(intr_acc_result(i) > 127.S){
          acc_reg(data_word_index)(i) := 127.S
        }
        .elsewhen(intr_acc_result(i) < -128.S){
          acc_reg(data_word_index)(i) := -128.S
        }
        .otherwise{
          acc_reg(data_word_index)(i) := intr_acc_result(i)
        }
      }
      .otherwise{
        when(intr_acc_result(i) > 49151.S){
          acc_reg(data_word_index)(i) := 49151.S
        }
        .elsewhen(intr_acc_result(i) < -49280.S){
          acc_reg(data_word_index)(i) := -49280.S
        }
        .otherwise {
          acc_reg(data_word_index)(i) := intr_acc_result(i)
        }
      }
      
      // when(sparse.start)
      // {
      //   when (vec_mul_wire(i) < (2.U << acc_reg_width)) {
      //     acc_reg(word_counter)(i) := vec_mul_wire(i)
      //   }
      //   .otherwise {
      //     acc_reg(word_counter)(i) := (2.U << acc_reg_width) - 1.U
      //   }
      // }
      // .otherwise{
      //   when ((vec_mul_wire(i) + acc_reg(word_counter)(i)) < (2.U << acc_reg_width)) {
      //     acc_reg(word_counter)(i) := vec_mul_wire(i) + acc_reg(word_counter)(i)
      //   }
      //   .otherwise {
      //     acc_reg(word_counter)(i) := (2.U << acc_reg_width) - 1.U
      //   }
      // }
    }
    word_counter := word_counter + 1.U
    when((word_counter === (dense_row_size - 1.U) && !sparse.last)) {
      word_counter := 0.U
      writeback_counter := 0.U
      sparse_valid := false.B
    }
  }

  val acc_result = WireInit(VecInit(Seq.fill(8) {0.S(8.W)}))
  for(i <- 0 until 8){
    acc_result(i) := acc_reg(writeback_counter)(i)(7,0).asTypeOf(SInt(8.W))
  }

  io.accumulator_mem_controller.valid := sparse_valid && word_counter === dense_row_size && writeback_counter <= (dense_row_size - 1.U)
  io.accumulator_mem_controller.bits := DontCare
  when (io.accumulator_mem_controller.fire()) {
    io.accumulator_mem_controller.bits.output_row_data := acc_result.asTypeOf(UInt(64.W))
    io.accumulator_mem_controller.bits.offset := writeback_counter
    writeback_counter := writeback_counter + 1.U
    when(writeback_counter === (dense_row_size - 1.U) && sparse.last) {
      word_counter := 0.U
      writeback_counter := 0.U
      sparse_valid := false.B
    }
  }
}
