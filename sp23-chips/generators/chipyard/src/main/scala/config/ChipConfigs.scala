package chipyard


import freechips.rocketchip.config.{Config}
import freechips.rocketchip.diplomacy.{AsynchronousCrossing}

import freechips.rocketchip.diplomacy._
import freechips.rocketchip.subsystem._
import constellation.channel._
import constellation.routing._
import constellation.router._
import constellation.topology._
import constellation.noc._
import constellation.soc.{GlobalNoCParams}
import scala.collection.immutable.ListMap

class BearlyConfig extends Config(
  // BEGIN: Common adjustments
  new chipyard.config.WithNPMPs(0) ++  
  new chipyard.config.WithL2TLBs(0) ++
  // TODO: add MultiRoCC trait in once all RoCC accelerators have been instantiated
  // new chipyard.config.WithMultiRoCC ++
  // END: Common adjustments

  new bearlynearmem.config.DMABearlyConfigFragment ++




  
  // BEGIN: SoC periphery
  // area io
  new chipyard.WithDummyGPIOCells ++
  new chipyard.CanHaveDummyIOCells ++
	new chipyard.WithDummyI2CIOCells ++
  new chipyard.WithDummyPWMIOCells ++
  new chipyard.WithDummyBareSPIIOCells ++
  
	new chipyard.WithDontTouchI2C ++
  new chipyard.WithDontTouchSPI ++

  new chipyard.WithBearlyBindingTable ++
  // area io

  new testchipip.WithSerialTLWidth(1) ++

  new chipyard.config.WithPWM(address = 0x10061000, channels = 2, cmpWidth = 32) ++
  new chipyard.config.WithPWM(address = 0x10060000, channels = 4) ++

  // TODO: add SPI back in once Intel SPIs are integrated (see IOBinders and Intech22Fragments)
  new chipyard.config.WithI2C(address = 0x10041000) ++
  new chipyard.config.WithI2C(address = 0x10040000) ++

  new chipyard.harness.WithSimSPIFlashModel(true) ++       // add the SPI flash model in the harness (writeable)  
  new chipyard.config.WithSPI(address = 0x10032000) ++
  new chipyard.config.WithSPIFlash(address = 0x10031000, fAddress = 0x40000000, size = 0x10000000) ++             // add the SPI psram controller (1 MiB)
  new chipyard.config.WithSPIFlash(address = 0x10030000, fAddress = 0x20000000, size = 0x10000000) ++             // add the SPI flash controller (1 MiB)
  new testchipip.WithCustomBootPinAltAddr(address = 0x20000000) ++                                // make custom boot address SPI base
  
  new chipyard.config.WithUART(address = 0x10022000, baudrate = 115200) ++
  new chipyard.config.WithUART(address = 0x10021000, baudrate = 115200) ++
  new chipyard.config.WithUARTOverride(address = 0x10020000, baudrate = 115200) ++

  new chipyard.config.WithGPIO(address = 0x10013000, width = 8) ++     // GPIOD
  new chipyard.config.WithGPIO(address = 0x10012000, width = 17) ++     // GPIOC
  new chipyard.config.WithGPIO(address = 0x10011000, width = 3) ++     // GPIOB
  new chipyard.config.WithGPIO(address = 0x10010000, width = 32) ++     // GPIOA

  new chipyard.config.WithJTAGDTMKey(partNum = 0x000, manufId = 0x489) ++

  new testchipip.WithBackingScratchpad(base = 0x08000000, mask = ((64<<10)-1)) ++ // 64 KB
  // END: SoC periphery

  new constellation.soc.WithSbusNoC(constellation.protocol.TLNoCParams(
    constellation.protocol.DiplomaticNetworkNodeMapping(
      inNodeMapping = ListMap(
        "Core 0" -> 0,
        "Core 1" -> 1,
        "Core 2" -> 2,
        "Core 3" -> 3,
        "near-mem-dma-read[0]" -> 5,
        "near-mem-dma-read[1]" -> 6,
        "near-mem-dma-read[2]" -> 7,
        "near-mem-dma-read[3]" -> 8,
        "near-mem-dma-write[0]" -> 5,
        "near-mem-dma-write[1]" -> 6,
        "near-mem-dma-write[2]" -> 7,
        "near-mem-dma-write[3]" -> 8,
        //following for sp-accel node
        "SPL2WriteNode[0]" -> 0,
        "SPL2WriteNode[1]" -> 1,
        "SPL2WriteNode[2]" -> 2,
        "SPL2WriteNode[3]" -> 3,
        "SPL2ReadNode[0]" -> 0,
        "SPL2ReadNode[1]" -> 1,
        "SPL2ReadNode[2]" -> 2,
        "SPL2ReadNode[3]" -> 3,
        //sp-accel node ends
        "serial-tl" -> 4),
      outNodeMapping = ListMap(
        "serdesser[0]" -> 5,
        "serdesser[1]" -> 6,
        "serdesser[2]" -> 7,
        "serdesser[3]" -> 8,
        "pbus" -> 4)), // TSI is on the pbus, so serial-tl and pbus should be on the same node
    NoCParams(
      topology        = UnidirectionalTorus1D(9),
      routerParams = (i) => UserRouterParams(payloadBits = 64),
      channelParamGen = (a, b) => UserChannelParams(Seq.fill(10) { UserVirtualChannelParams(4) }),
      routingRelation = NonblockingVirtualSubnetworksRouting(UnidirectionalTorus1DDatelineRouting(), 5, 2))
  )) ++
  new freechips.rocketchip.subsystem.WithInclusiveCache(nWays=8, capacityKB=256) ++
  new freechips.rocketchip.subsystem.WithNBanks(4) ++                                   // L2 (4 banks, 512KB total capacity)
  new chipyard.config.WithSystemBusWidth(64) ++                                         // System bus is 64 bit by default. Consider increasing to 128/256
  // END: Memory subsystem settings

  // BEGIN: Rocket SpecializedTile settings
  new freechips.rocketchip.subsystem.WithAsynchronousRocketTiles(depth=8, sync=3) ++

  // TODO: add prefetchers
  new prefetchers.WithPrefetcherMMIO ++
  new prefetchers.WithTLDCachePrefetcher(p = prefetchers.SingleBOPrefetcherParams()) ++
  new chipyard.config.WithTileToSBusPrefetchers ++         // use prefetcher
  // TODO: add RoCC Accelerators
  new chipyard.config.WithMultiRoCC ++
  
  //new chipyard.config.WithMultiRoCCFromBuildRoCC(0, 1, 2, 3) ++
  //new spaccel.WithSparseAccel ++

  new chipyard.config.WithMultiSparseAccelReserve(2, 3) ++
  new chipyard.config.WithMultiSparseAccel(0, 1) ++

  new freechips.rocketchip.subsystem.WithL1ICacheSets(64) ++
  new freechips.rocketchip.subsystem.WithL1ICacheWays(1) ++
  new freechips.rocketchip.subsystem.WithL1DCacheSets(64) ++
  new freechips.rocketchip.subsystem.WithL1DCacheWays(4) ++
  new freechips.rocketchip.subsystem.WithNBigCores(4) ++                                // 4 Rocket core
  // END: Rocket SpecializedTile settings


  // BEGIN: Integration/chiptop settings
  new chipyard.harness.WithSimAXIMemOverSerialTL ++                                     // Attach fast SimDRAM to TestHarness
  new chipyard.config.WithSerialTLBackingMemory ++                                      // Backing memory is over serial TL protocol
  new freechips.rocketchip.subsystem.WithExtMemSize((1 << 30) * 16L) ++                 // 16GB external memory


  //new chipyard.config.WithIntech22IOCells ++
  //new chipyard.config.WithIntech22GPIOCells ++

  new chipyard.config.WithTileFrequency(100.0) ++
  new chipyard.config.WithSystemBusFrequency(100.0) ++
  new chipyard.config.WithMemoryBusFrequency(100.0) ++
  new chipyard.config.WithPeripheryBusFrequency(100.0) ++
  new chipyard.config.WithSystemBusFrequencyAsDefault ++ // All unspecified clock frequencies, notably the implicit clock, will use the sbus freq (100 MHz)
  //  Crossing specifications
  new chipyard.clocking.WithClockGroupsCombinedByName("uncore", "implicit", "sbus", "mbus", "cbus", "system_bus") ++
  new chipyard.clocking.WithClockGroupsCombinedByName("fbus", "fbus", "pbus") ++
  new chipyard.config.WithCbusToPbusCrossingType(AsynchronousCrossing()) ++ // Add Async crossing between PBUS and CBUS
  new chipyard.config.WithSbusToMbusCrossingType(AsynchronousCrossing()) ++ // Can take this off
  new chipyard.config.WithFbusToSbusCrossingType(AsynchronousCrossing()) ++
  new testchipip.WithAsynchronousSerialSlaveCrossing ++ // Add Async crossing between serial and MBUS. Its master-side is tied to the FBUS
  new testchipip.WithSerialTLAsyncResetQueue ++ // Add Async reset queue to block ready while in reset

  new chipyard.harness.WithClockAndResetFromHarnessWithDebugAndLock ++
  new chipyard.iobinders.WithDividerAndPLLClockGenerator ++
  new chipyard.config.AbstractConfig)



class RoboConfig extends Config(
  // BEGIN: Common adjustments
  new chipyard.config.WithNPMPs(0) ++ // Remove all PMP features from cores
  new chipyard.config.WithL2TLBs(0) ++
  // TODO: add MultiRoCC trait in once all RoCC accelerators have been instantiated
  // END: Common adjustments

  // BEGIN: Accelerators 
  //new lqrRoCC.WithMultiRoCC ++
  new chipyard.config.WithMultiRoCC ++
  new chipyard.config.WithMultiLQR(1) ++
  new chipyard.config.WithKalmanFilterMulti(0) ++
  // END: Accelerators



  
  // BEGIN: SoC periphery
  // area io
  new chipyard.WithDummyGPIOCells ++
  new chipyard.CanHaveDummyIOCells ++
	new chipyard.WithDummyI2CIOCells ++
  new chipyard.WithDummyPWMIOCells ++
  new chipyard.WithDummyBareSPIIOCells ++
  
	new chipyard.WithDontTouchI2C ++
  new chipyard.WithDontTouchSPI ++

  new chipyard.WithRoboBindingTable ++
  // area io

  new testchipip.WithSerialTLWidth(1) ++

  new chipyard.config.WithPWM(address = 0x10061000, channels = 2, cmpWidth = 32) ++
  new chipyard.config.WithPWM(address = 0x10060000, channels = 4) ++

  // TODO: add SPI back in once Intel SPIs are integrated (see IOBinders and Intech22Fragments)
  new chipyard.config.WithI2C(address = 0x10041000) ++
  new chipyard.config.WithI2C(address = 0x10040000) ++

  new chipyard.harness.WithSimSPIFlashModel(false) ++       // add the SPI flash model in the harness (writeable)  
  new chipyard.config.WithSPI(address = 0x10032000) ++
  new chipyard.config.WithSPIFlash(address = 0x10031000, fAddress = 0x30000000, size = 0x10000000) ++             // add the SPI psram controller (1 MiB)
  new chipyard.config.WithSPIFlash(address = 0x10030000, fAddress = 0x20000000, size = 0x10000000) ++             // add the SPI flash controller (1 MiB)
  new testchipip.WithCustomBootPinAltAddr(address = 0x20000000) ++                                // make custom boot address SPI base
  
  new chipyard.config.WithUART(address = 0x10022000, baudrate = 115200) ++
  new chipyard.config.WithUART(address = 0x10021000, baudrate = 115200) ++
  new chipyard.config.WithUARTOverride(address = 0x10020000, baudrate = 115200) ++

  // new chipyard.config.WithGPIO(address = 0x10013000, width = 8) ++     // GPIOD
  new chipyard.config.WithGPIO(address = 0x10012000, width = 17) ++     // GPIOC
  new chipyard.config.WithGPIO(address = 0x10011000, width = 3) ++     // GPIOB
  new chipyard.config.WithGPIO(address = 0x10010000, width = 32) ++     // GPIOA

  new chipyard.config.WithJTAGDTMKey(partNum = 0x000, manufId = 0x489) ++

  new testchipip.WithBackingScratchpad(base = 0x08000000, mask = ((64<<10)-1)) ++ // 64 KB
  // END: SoC periphery


  // BEGIN: Memory subsystem settings
  // TODO: add backing scratchpad
  // TODO: add PSRAM widget
  new constellation.soc.WithSbusNoC(constellation.protocol.TLNoCParams(
    constellation.protocol.DiplomaticNetworkNodeMapping(
      inNodeMapping = ListMap(
        "Core 0" -> 0,
        "Core 1" -> 1,
        "Core 2" -> 2,
        "serial-tl" -> 3),
      outNodeMapping = ListMap(
        "serdesser[0]" -> 4,
        "serdesser[1]" -> 5,
        "serdesser[2]" -> 6,
        "serdesser[3]" -> 7,
        "pbus" -> 3)), // TSI is on the pbus, so serial-tl and pbus should be on the same node
    NoCParams(
      topology        = UnidirectionalTorus1D(8),
      routerParams = (i) => UserRouterParams(payloadBits = 64),
      channelParamGen = (a, b) => UserChannelParams(Seq.fill(10) { UserVirtualChannelParams(4) }),
      routingRelation = NonblockingVirtualSubnetworksRouting(UnidirectionalTorus1DDatelineRouting(), 5, 2))
  )) ++
  new freechips.rocketchip.subsystem.WithInclusiveCache(nWays=8, capacityKB=256) ++     // L2 (4 banks, 256 KB total capacity)
  new freechips.rocketchip.subsystem.WithNBanks(4) ++                                   // L2 (4 banks, 256 KB total capacity)
  new chipyard.config.WithSystemBusWidth(64) ++                                         // System bus is 64 bit.
  
  // END: Memory subsystem settings

  // BEGIN: Memory Tagging
  new boom.common.WithAsynchronousBoomTiles ++
  new boom.common.WithBoomSmallBPD ++ // For better area, use the smaller and simpler BPs
  new boom.common.WithBoomMTE(mteRegions = 
    List(
      /* Region 0 = scratchpad */
      boom.common.BoomMTERegion(
        base = 0x8000000L,
        size = 64L << 10
      ),
      /* Region 1 = DRAM */
      boom.common.BoomMTERegion(
        base = 0x80000000L,
        size = (1L << 30) * 16L
      ),
      //FIXME: CHECK MTE FOR PSRAM ONCE BASE AND SIZE ARE KNOWN
      /* Region 3 = PSRAM */
      boom.common.BoomMTERegion(
        base = 0x40000000L,
        size = (1L << 28)
      ),
    ),
    nWays = 4
  ) ++
  new boom.common.WithNMediumBooms(1) ++   
  // END: Memory Tagging

  // BEGIN: Rocket Kalman & LQR settings
  new freechips.rocketchip.subsystem.WithAsynchronousRocketTiles(depth=8, sync=3) ++
  //new lqrRoCC.WithLqrRoCC ++ 

  // TODO: add RoCC Accelerators
  new freechips.rocketchip.subsystem.WithL1ICacheSets(64) ++
  new freechips.rocketchip.subsystem.WithL1ICacheWays(1) ++
  new freechips.rocketchip.subsystem.WithL1DCacheSets(64) ++
  new freechips.rocketchip.subsystem.WithL1DCacheWays(4) ++
  new freechips.rocketchip.subsystem.WithNBigCores(2) ++                                // 2 Rocket core
  // END: Rocket SpecializedTile settings


  // BEGIN: Integration/chiptop settings
  new chipyard.harness.WithSimAXIMemOverSerialTL ++                                     // Attach fast SimDRAM to TestHarness
  new chipyard.config.WithSerialTLBackingMemory ++                                      // Backing memory is over serial TL protocol
  new freechips.rocketchip.subsystem.WithExtMemSize((1 << 30) * 16L) ++                 // 16GB external memory

  new chipyard.config.WithTileFrequency(100.0) ++
  new chipyard.config.WithSystemBusFrequency(100.0) ++
  new chipyard.config.WithMemoryBusFrequency(100.0) ++
  new chipyard.config.WithPeripheryBusFrequency(100.0) ++
  new chipyard.config.WithSystemBusFrequencyAsDefault ++ // All unspecified clock frequencies, notably the implicit clock, will use the sbus freq (100 MHz)
  //  Crossing specifications
  new chipyard.clocking.WithClockGroupsCombinedByName("uncore", "implicit", "sbus", "mbus", "cbus", "system_bus") ++
  new chipyard.clocking.WithClockGroupsCombinedByName("fbus", "fbus", "pbus") ++
  new chipyard.config.WithCbusToPbusCrossingType(AsynchronousCrossing()) ++ // Add Async crossing between PBUS and CBUS
  new chipyard.config.WithSbusToMbusCrossingType(AsynchronousCrossing()) ++ // Add Async crossings between backside of L2 and MBUS
  new chipyard.config.WithFbusToSbusCrossingType(AsynchronousCrossing()) ++
  new testchipip.WithAsynchronousSerialSlaveCrossing ++ // Add Async crossing between serial and MBUS. Its master-side is tied to the FBUS
  new testchipip.WithSerialTLAsyncResetQueue ++ // Add Async reset queue to block ready while in reset
  // END: Integration/chiptop settings
  new chipyard.harness.WithClockAndResetFromHarnessWithDebugAndLock ++
  new chipyard.iobinders.WithDividerAndPLLClockGenerator ++
  new chipyard.config.AbstractConfig)
