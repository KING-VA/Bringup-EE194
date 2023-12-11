// $Log$
//
// 2020-11-12 17:25:19 f7e2fe8b Remove in-file logs
// 2018-05-04 15:05:38 a878bf81 define _drSELPOWERLIST _drSELGROUNDLIST sel_memory_list sel_low_list for SELDPM flow
// 2018-03-07 11:37:45 6604dcd6 moved lu_system_io_list to UserDefines
// 2017-11-16 10:53:16 a0e89315 defined latchup_internal_io_list used in drc_LU flow to identify the internal IO nets for LU_90
// 2017-07-14 10:18:27 072c0a40 HSD 220284718: removed the _drUSERDEFINESUIN switch
// 2017-04-27 22:40:34 1519dd3f removed latchup_voltage_list/latchup_voltage_PWR/latchup_voltage_GND. These lists are replaced with allPower_allGround/notPower_notGround
// 2016-11-16 10:16:00 ff94c8e0 Defined super_high_voltage (SHV) list.
// 2016-08-12 11:20:06 9ace18e7 removed vcchvio1_hv from hv/ehv lists
// 2016-06-29 12:20:53 5d445f5a Added gated/not_gated power lists for LU_08/09
// 2016-06-13 15:53:42 992dd374 Removed global density target definitions
// 2016-05-31 23:45:43 0e0b669c changed #include <my_userdefines.rs> to $include <proj_config/my_userdefines.rs> so that my_userdefines can be in proj_config directory
// 2016-03-15 23:24:09 b7b2771c Define latchup_voltage_PWR and latchup_voltage_GND
// 2016-03-04 17:09:36 6949c3d4 Initial list for RHV
// 2016-01-11 18:09:46 707855da since 1222 has deepnwell enabled, change lvs ground from vss to vss*
// 2015-12-14 15:30:40 1f49c891 create high_voltage_list_gt1417 list same defautls as HV
// 2015-11-04 22:07:25 0e76fc60 define a name for wafersub
// 2015-11-02 22:09:07 3b0ca311 copied from 1222
//

// *************************************************************************************
// DRC Control variables

// DRC signal lists ; should really be case-insensitive and specified as UC
// ultra_high_voltage_list
// but when used in the trace flows they will be case sensitive

super_high_voltage_list = {
    "*_SHV", "*_shv"
  };
  
  real_high_voltage_list = {
    "*_RHV", "*_rhv"
  };
  
   ultra_high_voltage_list = { 
        "*_UHV", "*_uhv" 
   };
  
  // extra_high_voltage_list
  extra_high_voltage_list = { 
        "*_EHV", "*_ehv" 
  };
  
  // high_voltage_list
  high_voltage_list = { 
        "*_HV", "*_hv" 
  }; 
  
  // high_voltage_list > 1.417volts // this if for MIMS
  high_voltage_list_gt1417 = { 
        "*_HV", "*_hv" 
  }; 
  
  // nominal_voltage_list
  nominal_voltage_list = { 
        "*_NOM", "*_nom", "vss", "VSS", "vssx" 
  }; 
  
  // *************************************************************************************
  // TRC/LVS Control variables
  
  // waferSub name
  waferSubName:string = "wafersub";
  
  // LVS power/grounds lists ; user controlled case sensitivity default will be UC
  // schematic power/ground for lvs
  _dr_lvsSchematicPower = {
        "vcc", "vxx", "vccxx", "VDD", "VDDV" 
  };
  _dr_lvsSchematicGround = { 
        "vss", "vssx", "VSS" 
  };
  
  // layout power/ground for lvs
  _dr_lvsLayoutPower = {
        "vcc", "vxx", "vccxx", "VDD", "VDDV" 
  };
  
  _dr_lvsLayoutGround = { 
        "vss", "vssx", "VSS" 
  };
  
  //latch-up voltage list, project should add the non-io power nodes that are falsely identified as injector
  latchup_gated_pwr_list = { "", };
  latchup_gated_gnd_list = { "", };
  latchup_internal_io_list = { "", };
  
  // *************************************************************************************
  // It's a project's responsibility to put here a complete and correct list
  // of all the system-level exposed pins in the product. e.g:
  // "xx",
  // "abc",
  
  // flagging everything (i.e. overflagging) by default.  Remove the line with
  // "*", when the real list has been populated
  
  lu_system_io_list = {
  
  #include <proj_config/prj_lu_system_io>
  
  };
  
  // *************************************************************************************
  // SEL variables
  // these are the local power names (i.e. the name used in the base sram / standard cells)
  _drSELPOWERLIST:list of string  = { "*vcc*", }; // as per adam email more pessimistic but OK
  _drSELGROUNDLIST:list of string = { "*vss*",  };
  // this will be list of cells to synthesize the appropriate ID by name (expects cell has CELLBOUNDARY)
  sel_memory_list:list of string = {};
  sel_low_list:list of string = {};
  
  // *************************************************************************************
  // Density Control variables
  
  // Density Window overlap waivers at Reuse IP ring boundary 
  collat_reuse_via_w = 0.0; // Area that has only 0% area outside ring is not checked
  collat_reuse_cd_w = 0.0; // Non Via Area waive for concentrated density
  collat_reuse_cm_w = 0.0; // Non Via Area waive for cumulative density
  collat_reuse_ld_w = 0.0; // Non Via Area waive for local density
  g_Collat_winScale = 2.0; // 2 == 1/2 window 1 == full window 
  
  
  // control whether user defines are loaded
  //#ifdef _drUSERDEFINESUIN
     #include <proj_config/my_userdefines.rs>
  //#endif 
  
  