package lqrRoCC

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._

class datapath(val data_w: Int = 32, val n: Int = 16) extends Module {
  val io = IO(new Bundle {
    val vec1 =  Input(Vec(n,UInt(data_w.W)))
    val vec2 =  Input(Vec(n,UInt(data_w.W)))
    val enable = Input (Bool())
    val valid = Output (Bool())
    val out = Output(UInt(data_w.W))
  })

  val comp_idle :: comp_do :: comp_commit :: Nil = Enum(3)
  val comp_state = RegInit(comp_idle)

  io.out := 0.U
  io.valid := false.B
  val downcounter = RegInit(0.U(3.W)) // need 4 cycle of delay on the adder

  val dotComputeUnit = Module(new dotCompute(data_w, n))
  for (i <- 0 until n){
    dotComputeUnit.io.vec1(i) := io.vec1(i)
    dotComputeUnit.io.vec2(i) := io.vec2(i)
  }

  switch (comp_state){
    is(comp_idle){
        io.valid := false.B

        when(io.enable === true.B){
            downcounter := 4.U
            comp_state := comp_do
        }.otherwise{
            comp_state := comp_idle
        }
    }
    is(comp_do){
        // since there is a register between mul and add
        // latch here by 1 cycle
        // TODO: Might need more latch cycles here (like a countdown counter)
        downcounter := downcounter - 1.U
        io.valid := false.B
        when(downcounter === 0.U){
          comp_state := comp_commit
        }.otherwise{
          comp_state := comp_do
        }
    }
    is(comp_commit){
        io.valid := true.B
        io.out := dotComputeUnit.io.out
        comp_state := comp_idle
    }

  }

}