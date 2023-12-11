package spaccel_reserve

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import chisel3.experimental.IntParam
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._



class Cmd_to_Spload_Bundle extends Bundle {
  val sp_ptr  = UInt(64.W)
  val sp_size = UInt(8.W)
  val d_ptr   = UInt(64.W)
  val out_ptr = UInt(64.W)
}

class Spload_to_DenseAccum_Bundle extends Bundle {
  val sp_idx   = UInt(8.W)
  val sp_data  = UInt(8.W)    // will be casted into S_Int later
  val d_ptr    = UInt(64.W)
  val out_ptr  = UInt(64.W)
  val finished = Bool()       // important signal, indicate this is the last sp_chunk
}

class DenseAccum_to_Writer_Bundle extends Bundle {
  val out_ptr       = UInt(64.W)
  val out_data      = UInt(64.W)   //this contains many signed int
  val transfer_ctr  = UInt(4.W)    //total of 16 blocks will be transferred 
}






