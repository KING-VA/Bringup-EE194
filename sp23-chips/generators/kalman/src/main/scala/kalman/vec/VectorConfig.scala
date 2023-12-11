package kalman.vec

import chisel3._
import hardfloat.{fNFromRecFN, recFNFromFN}

case class VectorConfig(itemSize: Int, numItems: Int, numVectors: Int) {
  def encodedItemSize: Int = { itemSize + 1 }
  def wordSize: Int = { 64 }
  def expWidth: Int = { IEEE754Map.exp(itemSize) }
  def sigWidth: Int = { IEEE754Map.sig(itemSize) }
  def itemsPerWord: Int = { wordSize / itemSize }
  def decode(in: UInt): UInt = { fNFromRecFN(this.expWidth, this.sigWidth, in) }
  def encode(in: UInt): UInt = { recFNFromFN(this.expWidth, this.sigWidth, in) }
}
