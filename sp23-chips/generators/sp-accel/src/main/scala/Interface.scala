package spaccel

import chisel3._
import chisel3.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import chisel3.experimental.IntParam
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._


class DenseLoadControllerCmd extends Bundle {
  val dense_matrix_ptr = UInt(64.W)
  val dense_row_size = UInt(8.W)
  val is_virtual_addr = Bool()
}

class AccumulatorCmd extends Bundle {
  val dense_row_size = UInt(8.W)
}

class SparseDecoderDenseLoadControllerInterface extends Bundle {
  val idx = UInt(8.W)
}

class DenseRowControllerMemControllerInterface extends Bundle {
  val dense_row_pointer = UInt(64.W)
  val is_virtual_addr = Bool()
}

class SparseLoadControllerCmd extends Bundle {
  //val sparse_row_pointer = UInt(64.W)
  val spPtr = UInt(64.W)
  val spSize = UInt(8.W)
  val is_virtual_addr = Bool()
}

class SparseLoadControllerMemControllerInterface extends Bundle {
  //val sparse_pointer = UInt(64.W)
  val memPtr = UInt(64.W)
  val startRowChunk = Bool()
  val endRowChunk = Bool()
  val is_virtual_addr = Bool()
}

class MemControllerSparseDecoderInterface extends Bundle {
  val spRow = UInt(64.W)
  val startRowChunk = Bool()
  val endRowChunk = Bool()
}

class MemControllerAccumulatorInterface extends Bundle {
  val dense_row_data = UInt(64.W)
  val data_index = UInt(8.W) // Providing index becasuse L2 burst data return Out of Order
}

class SparseDecoderAccumulatorInterface extends Bundle {
  val weight = UInt(8.W)
  val startRowWeight = Bool()
  val endRowWeight = Bool()
}

class AccumulatorMemControllerInterface extends Bundle {
  val offset = UInt(8.W)
  val output_row_data = UInt(64.W)
}

class MemControllerCmd extends Bundle {
  val output_row_pointer = UInt(64.W)
  val is_virtual_addr = Bool()
}

class MemControllerInFlightQueueBundle extends Bundle {
  val data = UInt(64.W)
  val entry_id = UInt(2.W)
  val client_id = UInt(2.W)
  val start = Bool()
  val last = Bool()
}

class MemControllerPTWVirtualInterface extends Bundle {
  val virtual_addr = UInt(64.W)
}

class MemControllerPTWPhysicalInterface extends Bundle {
  val physical_addr = UInt(64.W)
}


class WriteLUTCmd extends Bundle {
  val data1 = UInt(64.W) 
  val data2 = UInt(64.W) 
}

class ReadLUTData extends Bundle {
  val data = UInt(64.W) 
}

class ReadLUTCmd extends Bundle {
  val wantToRead = UInt(2.W)
}

class VirtualWeightControllerSparseDecoderInterface extends Bundle {
  val spRow = UInt(64.W)
  val startRowChunk = Bool()
  val endRowChunk = Bool()
}

class LUTVirtualWeightControllerInterface extends Bundle {
  val centroids = UInt(64.W)
  val startRowWeight = Bool()
  val endRowWeight = Bool()
}

class MemControllerVirtualWeightControllerInterface extends Bundle {
  val spRow = UInt(64.W)
  val startRowChunk = Bool()
  val endRowChunk = Bool()
}

class LUTControllerCmd extends Bundle {
  val switch = UInt(2.W) // This is true when when turn on the LUT and index accumulation, and is false when we turn off the LUT and index accumulation
}