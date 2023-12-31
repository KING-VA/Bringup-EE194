package sifive.blocks.devices.spi

import Chisel.{defaultCompileOptions => _, _}
import freechips.rocketchip.util.CompileOptions.NotStrictInferReset
import chisel3.{withClockAndReset}
import freechips.rocketchip.util.{SynchronizerShiftReg}
import sifive.blocks.devices.pinctrl.{PinCtrl, Pin}

class SPISignals[T <: Data](private val pingen: () => T, c: SPIParamsBase) extends SPIBundle(c) {

  val sck = pingen()
  val dq  = Vec(4, pingen())
  val cs  = Vec(c.csWidth, pingen())
}

class SPIPins[T <: Pin] (pingen: ()=> T, c: SPIParamsBase) extends SPISignals(pingen, c)

object SPIPinsFromPort {
  
  def apply[T <: Pin](pins: SPISignals[T], spi: SPIPortIO, clock: Clock, reset: Bool,
    syncStages: Int = 0, driveStrength: Bool = Bool(false)) {

    withClockAndReset(clock, reset) {
      pins.sck.outputPin(spi.sck, ds0 = driveStrength)

      (pins.dq zip spi.dq).zipWithIndex.foreach {case ((p, s), i) =>
        p.outputPin(s.o, pullup_en = Bool(true), ds0 = driveStrength)
        p.o.oe := s.oe
        p.o.ie := ~s.oe
        s.i := SynchronizerShiftReg(p.i.ival, syncStages, name = Some(s"spi_dq_${i}_sync"))
      }

      (pins.cs zip spi.cs) foreach { case (c, s) =>
        c.outputPin(s, ds0 = driveStrength)
      }
    }
  }
}

/*
   Copyright 2016 SiFive, Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
