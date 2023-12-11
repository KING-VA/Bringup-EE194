package spaccel

import chisel3._
import chisel3.util._
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec 

class AccelSparseDecoderTest extends AnyFreeSpec with ChiselScalatestTester {
    "Testcase" in {
        test(new AccelSparseDecoder()) { c=>
            // Send a row of 3 row chunks
            // Sending chunk 1
            c.io.inputBundle.bits.spRow.poke("h__04_ff__bb_aa__07_00__03_01".U)
            c.io.inputBundle.bits.startRowChunk.poke(true.B)
            c.io.inputBundle.bits.endRowChunk.poke(false.B)
            c.io.inputBundle.valid.poke(true.B)
            c.clock.step(1)
            // Output 1st element
            c.io.outputBundleAcc.valid.expect(true.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(true.B)
            
            c.io.outputBundleAcc.bits.weight.expect("h_01".U)
            c.io.outputBundleAcc.bits.startRowWeight.expect(true.B)
            c.io.outputBundleAcc.bits.endRowWeight.expect(false.B)

            c.io.outputBundleDenseLoadCtrl.bits.idx.expect("h_03".U)

            c.io.outputBundleAcc.ready.poke(true.B)
            c.io.outputBundleDenseLoadCtrl.ready.poke(true.B)

            c.clock.step(1)
            // Output 2nd element
            c.io.outputBundleAcc.valid.expect(true.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(true.B)
            
            c.io.outputBundleAcc.bits.weight.expect("h_00".U)
            c.io.outputBundleAcc.bits.startRowWeight.expect(false.B)
            c.io.outputBundleAcc.bits.endRowWeight.expect(false.B)

            c.io.outputBundleDenseLoadCtrl.bits.idx.expect("h_07".U)

            c.clock.step(1)
            // Output 3rd element
            c.io.outputBundleAcc.valid.expect(true.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(true.B)
            
            c.io.outputBundleAcc.bits.weight.expect("h_aa".U)
            c.io.outputBundleAcc.bits.startRowWeight.expect(false.B)
            c.io.outputBundleAcc.bits.endRowWeight.expect(false.B)

            c.io.outputBundleDenseLoadCtrl.bits.idx.expect("h_bb".U)

            c.clock.step(1)
            // Output 4th element
            c.io.outputBundleAcc.valid.expect(true.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(true.B)
            
            c.io.outputBundleAcc.bits.weight.expect("h_ff".U)
            c.io.outputBundleAcc.bits.startRowWeight.expect(false.B)
            c.io.outputBundleAcc.bits.endRowWeight.expect(false.B)

            c.io.outputBundleDenseLoadCtrl.bits.idx.expect("h_04".U)

            c.clock.step(1)
            // No element output
            c.io.outputBundleAcc.valid.expect(false.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(false.B)

            // Sending chunk 2
            c.io.inputBundle.bits.spRow.poke("h__00_ef__ba_ba__09_10__23_20".U)
            c.io.inputBundle.bits.startRowChunk.poke(false.B)
            c.io.inputBundle.bits.endRowChunk.poke(false.B)
            c.io.inputBundle.valid.poke(true.B)
            c.clock.step(1)

            // Output 1st element
            c.io.outputBundleAcc.valid.expect(true.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(true.B)
            
            c.io.outputBundleAcc.bits.weight.expect("h_20".U)
            c.io.outputBundleAcc.bits.startRowWeight.expect(false.B)
            c.io.outputBundleAcc.bits.endRowWeight.expect(false.B)

            c.io.outputBundleDenseLoadCtrl.bits.idx.expect("h_23".U)

            c.io.outputBundleAcc.ready.poke(true.B)
            c.io.outputBundleDenseLoadCtrl.ready.poke(true.B)

            c.clock.step(1)
            // Output 2nd element
            c.io.outputBundleAcc.valid.expect(true.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(true.B)
            
            c.io.outputBundleAcc.bits.weight.expect("h_10".U)
            c.io.outputBundleAcc.bits.startRowWeight.expect(false.B)
            c.io.outputBundleAcc.bits.endRowWeight.expect(false.B)

            c.io.outputBundleDenseLoadCtrl.bits.idx.expect("h_09".U)

            c.clock.step(1)
            // Output 3rd element
            c.io.outputBundleAcc.valid.expect(true.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(true.B)
            
            c.io.outputBundleAcc.bits.weight.expect("h_ba".U)
            c.io.outputBundleAcc.bits.startRowWeight.expect(false.B)
            c.io.outputBundleAcc.bits.endRowWeight.expect(false.B)

            c.io.outputBundleDenseLoadCtrl.bits.idx.expect("h_ba".U)

            c.clock.step(1)
            // Output 4th element
            c.io.outputBundleAcc.valid.expect(true.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(true.B)
            
            c.io.outputBundleAcc.bits.weight.expect("h_ef".U)
            c.io.outputBundleAcc.bits.startRowWeight.expect(false.B)
            c.io.outputBundleAcc.bits.endRowWeight.expect(false.B)

            c.io.outputBundleDenseLoadCtrl.bits.idx.expect("h_00".U)

            c.clock.step(1)
            // No element output
            c.io.outputBundleAcc.valid.expect(false.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(false.B)

            // Sending chunk 3
            c.io.inputBundle.bits.spRow.poke("h__11_aa__cc_ca__26_11__18_22".U)
            c.io.inputBundle.bits.startRowChunk.poke(false.B)
            c.io.inputBundle.bits.endRowChunk.poke(true.B)
            c.io.inputBundle.valid.poke(true.B)
            c.clock.step(1)

            // Output 1st element
            c.io.outputBundleAcc.valid.expect(true.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(true.B)
            
            c.io.outputBundleAcc.bits.weight.expect("h_21".U)
            c.io.outputBundleAcc.bits.startRowWeight.expect(false.B)
            c.io.outputBundleAcc.bits.endRowWeight.expect(false.B)

            c.io.outputBundleDenseLoadCtrl.bits.idx.expect("h_18".U)

            c.io.outputBundleAcc.ready.poke(true.B)
            c.io.outputBundleDenseLoadCtrl.ready.poke(true.B)

            c.clock.step(1)
            // Output 2nd element
            c.io.outputBundleAcc.valid.expect(true.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(true.B)
            
            c.io.outputBundleAcc.bits.weight.expect("h_11".U)
            c.io.outputBundleAcc.bits.startRowWeight.expect(false.B)
            c.io.outputBundleAcc.bits.endRowWeight.expect(false.B)

            c.io.outputBundleDenseLoadCtrl.bits.idx.expect("h_26".U)

            c.clock.step(1)
            // Output 3rd element
            c.io.outputBundleAcc.valid.expect(true.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(true.B)
            
            c.io.outputBundleAcc.bits.weight.expect("h_ca".U)
            c.io.outputBundleAcc.bits.startRowWeight.expect(false.B)
            c.io.outputBundleAcc.bits.endRowWeight.expect(false.B)

            c.io.outputBundleDenseLoadCtrl.bits.idx.expect("h_cc".U)

            c.clock.step(1)
            // Output 4th element
            c.io.outputBundleAcc.valid.expect(true.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(true.B)
            
            c.io.outputBundleAcc.bits.weight.expect("h_aa".U)
            c.io.outputBundleAcc.bits.startRowWeight.expect(false.B)
            c.io.outputBundleAcc.bits.endRowWeight.expect(true.B)

            c.io.outputBundleDenseLoadCtrl.bits.idx.expect("h_11".U)

            c.clock.step(1)
            // No element output
            c.io.outputBundleAcc.valid.expect(false.B)
            c.io.outputBundleDenseLoadCtrl.valid.expect(false.B)

        }
    }
}