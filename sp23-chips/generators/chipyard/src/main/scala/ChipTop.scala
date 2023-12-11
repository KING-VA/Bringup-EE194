package chipyard

import chisel3._
import scala.util.control.Breaks._

import scala.collection.mutable.{ArrayBuffer}
import freechips.rocketchip.diplomacy.{InModuleBody}
import freechips.rocketchip.prci.{ClockGroupIdentityNode, ClockSinkParameters, ClockSinkNode, ClockGroup}
import freechips.rocketchip.subsystem.{BaseSubsystem, SubsystemDriveAsyncClockGroupsKey}
import freechips.rocketchip.config.{Parameters, Field}
import freechips.rocketchip.diplomacy.{LazyModule, LazyModuleImp, LazyRawModuleImp, LazyModuleImpLike, BindingScope}
import freechips.rocketchip.util.{ResetCatchAndSync}
import chipyard.iobinders._
import barstools.iocell.chisel._
import chisel3.ExplicitCompileOptions.Strict
import scala.collection.mutable.ListBuffer


case object BuildSystem extends Field[Parameters => LazyModule]((p: Parameters) => new DigitalTop()(p))

/**
 * The base class used for building chips. This constructor instantiates a module specified by the BuildSystem parameter,
 * named "system", which is an instance of DigitalTop by default. The diplomatic clocks of System, as well as its implicit clock,
 * is aggregated into the clockGroupNode. The parameterized functions controlled by ClockingSchemeKey and GlobalResetSchemeKey
 * drive clock and reset generation
 */

class ChipTop(implicit p: Parameters) extends LazyModule with BindingScope
    with HasIOBinders {
  // The system module specified by BuildSystem
  lazy val lazySystem = LazyModule(p(BuildSystem)(p)).suggestName("system")

  // NOTE: Making this a LazyRawModule is moderately dangerous, as anonymous children
  // of ChipTop (ex: ClockGroup) do not receive clock or reset.
  // However. anonymous children of ChipTop should not need an implicit Clock or Reset
  // anyways, they probably need to be explicitly clocked.

  // Intech22 GPIO Constant
  val WNUM_INST = p(BindingTableType) match { // Number of west slice instances; used only if slices are place next to each other
    case BindingTableParams("robo")   => 9
    case BindingTableParams("bearly") => 9
    case _ => throw new Exception("Binding table type not specified (done with config fragaments)")
  }

  val SNUM_INST     = 9   // Number of west slice instances; used only if slices are place next to each other
  // Constant to index list of slice
  val WEST_INDEX    = 0
  val SOUTH_INDEX   = WEST_INDEX + WNUM_INST
  val CORNER_INDEX  = SOUTH_INDEX + SNUM_INST

  // Default GPIO configation for control bits
  val cellConfigDefaultMap = Map (
    "drv0"          -> 0.B,     // In combination with other bits highest drive strength
    "drv1"          -> 0.B,     // In combination with other bits highest drive strength
    "drv2"          -> 0.B,     // In combination with other bits highest drive strength
    "enabq"         -> 1.B,     // Disable receiver
    "enq"           -> 1.B,     // Disable transmitter
    "pd"            -> 0.B,     // Disable pull down
    "ppen"          -> 1.B,     // Push-pull output
    "prg_slew"      -> 1.B,     // Faster slew rate
    "puq"           -> 1.B,     // Disable pull up
    "pwrup_pull_en" -> 0.B,     // Disable; normal operation mode
    "pwrupzhl"      -> 0.B)     // Normal operation mode


  InModuleBody {

    println("\n\nGPIO ports in design:")
    for (g <- GPIOPins.gpioPins) { println(s"    $g") }

    println("\n\nSPI (bidirectional) ports in design:")
    for (g <- GPIOPins.spiPorts) { println(s"    $g") }

    println("\n\nI2C ports in design:")
    for (g <- GPIOPins.i2cPorts) { println(s"    $g") }

    // Instantiate slices black box (DO NOT TOUCH; GENERATED NAME FROM VARIABLE NAME)
    val corner_io                           = Seq(Module(new hl_corner_io_wrapper()))
    val west_io  : Seq[hl_west_io_wrapper]  = Seq.fill(WNUM_INST)(Module(new hl_west_io_wrapper()))
    val south_io : Seq[hl_south_io_wrapper] = Seq.fill(SNUM_INST)(Module(new hl_south_io_wrapper()))
    // Concatenate for easier handling
    var io_slices : Seq[Intech22Slice] = west_io ++ south_io ++ corner_io

    // Build vector to non-pad assigns
    var slice_pad_skip  = ListBuffer[(Int, Int)]()

    // /////////////////////////////////////////////////// PLACEHOLDER EXAMPLE
    // // This is example of using the slice_placeholder
    // // Here 8 west slice are followed by a placeholder and
    // // another west slice. The south and corner slices are
    // // instantiated as expected (8 south and 1 corner).
    // // Point to note, that if the enumeration of west slices
    // // is desired as if placeholder not interested you must
    // // use suggestName as shown
    // var io_slices : Seq[Intech22Slice] =  Seq.fill(7)(Module(new hl_west_io_wrapper())) ++
    //                                       Seq(Module(new slice_placeholder())) ++
    //                                       Seq(Module(new hl_west_io_wrapper()).suggestName("Bang")) ++
    //                                       Seq.fill(SNUM_INST)(Module(new hl_south_io_wrapper())) ++
    //                                       Seq(Module(new hl_corner_io_wrapper()))
    // // This example shows using suggest name after instantiation
    // io_slices(5).asInstanceOf[hl_west_io_wrapper].suggestName("BOOM")
    // ///////////////////////////////////////////////////

    // Tie all inputs to ground to prevent optimization
    for (slice <- io_slices) {
      var len = slice.io.dq.length
      slice.io.dq             := DontCare //VecInit(Seq.fill(len)(cellConfigDefaultMap("dq")))
      slice.io.drv0           := VecInit(Seq.fill(len)(cellConfigDefaultMap("drv0")))
      slice.io.drv1           := VecInit(Seq.fill(len)(cellConfigDefaultMap("drv1")))
      slice.io.drv2           := VecInit(Seq.fill(len)(cellConfigDefaultMap("drv2")))
      slice.io.enabq          := VecInit(Seq.fill(len)(cellConfigDefaultMap("enabq")))
      slice.io.enq            := VecInit(Seq.fill(len)(cellConfigDefaultMap("enq")))
      slice.io.pd             := VecInit(Seq.fill(len)(cellConfigDefaultMap("pd")))
      slice.io.ppen           := VecInit(Seq.fill(len)(cellConfigDefaultMap("ppen")))
      slice.io.prg_slew       := VecInit(Seq.fill(len)(cellConfigDefaultMap("prg_slew")))
      slice.io.puq            := VecInit(Seq.fill(len)(cellConfigDefaultMap("puq")))
      slice.io.pwrup_pull_en  := VecInit(Seq.fill(len)(cellConfigDefaultMap("pwrup_pull_en")))
      slice.io.pwrupzhl       := VecInit(Seq.fill(len)(cellConfigDefaultMap("pwrupzhl")))
    }


    def wireIOBinder[T](cell : T, cell_name : String,  entry : SignalBinderConnection): Unit = {
      // Get index of slice instance
      var slice_ind = entry.slice_type match {
        case "W" => { WEST_INDEX   + entry.slice_inst}
        case "S" => { SOUTH_INDEX  + entry.slice_inst}
        case "C" => { CORNER_INDEX + entry.slice_inst}
      }

      var slice = io_slices(slice_ind)
      slice_pad_skip += ((slice_ind, entry.bit))


      // Connect pads and enables (signals passed through DummyIO/non-configuration bits)
      cell match {
        case dummy_cell : DummyInIOCell => {
          slice.io.enabq(entry.bit) := ~dummy_cell.io.ie_cell
          slice.io.enq(entry.bit)   := true.B
          dummy_cell.io.i_cell      := slice.io.outi(entry.bit)
          slice.io.pad(entry.bit)   <> dummy_cell.io.pad_cell
        }
        case dummy_cell : DummyOutIOCell => {
          slice.io.enabq(entry.bit) := true.B
          slice.io.enq(entry.bit)   := ~dummy_cell.io.oe_cell
          slice.io.dq(entry.bit)    := ~dummy_cell.io.o_cell    // pad is negated dq
          slice.io.pad(entry.bit)   <> dummy_cell.io.pad_cell
        }
        case dummy_cell : DummyGPIOCell => {
          slice.io.dq(entry.bit)  := ~dummy_cell.io.o_cell      // Input connection
          dummy_cell.io.i_cell    := slice.io.outi(entry.bit)   // Output connection
          slice.io.pad(entry.bit) <> dummy_cell.io.pad_cell     // Pad connection
          if (cell_name contains "gpio") {
            val pin = GPIOPins.gpioPins(cell_name)
            slice.io.enq(entry.bit)   := ~pin.o.oe
            slice.io.enabq(entry.bit) := ~pin.o.ie
          } else {
            slice.io.enq(entry.bit)   := ~dummy_cell.io.oe_cell
            slice.io.enabq(entry.bit) := ~dummy_cell.io.ie_cell
          }
        }
        case _ => { println("ERROR: Attempting to connect incorrect type of IOBinder (ChipTop.scala)")}
      }

      if (cell_name contains "gpio") {
        val pin = GPIOPins.gpioPins(cell_name)
        // Configuration bits
        slice.io.drv2(entry.bit)          := pin.o.ds2
        slice.io.drv1(entry.bit)          := pin.o.ds1
        slice.io.drv0(entry.bit)          := pin.o.ds0
        slice.io.pd(entry.bit)            := pin.o.pulldown_en
        slice.io.puq(entry.bit)           := pin.o.pullup_en
        slice.io.ppen(entry.bit)          := pin.o.mode
        slice.io.prg_slew(entry.bit)      := pin.o.prog_slew
        slice.io.pwrup_pull_en(entry.bit) := false.B
        slice.io.pwrupzhl(entry.bit)      := false.B

      } else {
        // Configuration bits
        slice.io.drv2(entry.bit)          := entry.drv2
        slice.io.drv1(entry.bit)          := entry.drv1
        slice.io.drv0(entry.bit)          := entry.drv0
        slice.io.pd(entry.bit)            := entry.pd
        slice.io.puq(entry.bit)           := entry.puq
        slice.io.ppen(entry.bit)          := entry.ppen
        slice.io.prg_slew(entry.bit)      := entry.prg_slew
        slice.io.pwrup_pull_en(entry.bit) := entry.pwrup_pull_en
        slice.io.pwrupzhl(entry.bit)      := entry.pwrupzhl

      }
    }


    // Select the appropriate binding table
    var sigBinderTable = p(BindingTableType) match {
      case BindingTableParams("robo")   => SigTable.roboSigBinderTable
      case BindingTableParams("bearly") => SigTable.bearlySigBinderTable
      case _ => throw new Exception("Binding table type not specified (done with config fragaments)")
    }
    
    println("\n\n\n\nSignal Search")
    for (v <- iocells) {
      var name: String = v.iocell_name.get
      sigBinderTable.keySet.contains(name.replace("iocell_", "")) match {
        case true => {
          wireIOBinder[IOCell](v, name, sigBinderTable(name.replace("iocell_", "")))
          println("matched " + v.iocell_name.get)
        }
        case false => {
          assert(false, "No match found for " + name.replace("iocell_", ""))
        }
      }
    }
    println("Found all signals.")



    for ((slice, slice_ind) <- io_slices.zipWithIndex) {
      for (n <- 0 to slice.io.pad.length-1) {
        if (!(slice_pad_skip contains (slice_ind, n))) {
          io_slices(slice_ind).io.pad(n) <> DontCare
        }
      }
    }
  }


  lazy val module: LazyModuleImpLike = new LazyRawModuleImp(this)

}