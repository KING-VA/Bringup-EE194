#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# --------------------------------
# PRIMARY UTIL DRIVER
# last Modified: 02/25/22, Reza S
# --------------------------------

import json
import os

from IntelBumpUtil import BumpMapUni22
import IntelConstants as IC
import yaml
from BumpUtils import GridDomain
from GenUtils import GeneralUtil, SupplyInfoDefinition, GroundInfoDefinition
from sty import fg, ef, rs
from pathlib import Path
from BumpInfo import bearly_table

# ---------------------------------------------------------------------------
# SWITCHES
# ---------------------------------------------------------------------------
# Control the scoping of what is generated with these switches. 
# The notion being that in some cases, you may wish to only include the 
# the generated yaml file instead of having it as a primary design spec.

GEN_DESIGN_JSON = True # Master switch, toggles final json file generation.
GEN_SRC         = False
GEN_CLKS        = False
GEN_PLACEMENT   = False
GEN_DIE_RING    = False 
GEN_CPF         = True
GEN_SUPPLIES    = True
GEN_BUMPS       = True
GEN_EXTRA_LIBS  = True
GEN_PAD_RING    = False

placement_constr_list = []
extra_lib_list        = []

# ---------------------------------------------------------------------------
# DESIGN CONSTANTS
# ---------------------------------------------------------------------------
# --- PATHING ---
proj_path = "/tools/C/ee290-sp23"
out_file_path = os.environ["design_conf_gen"]
gen_file_path = os.environ["gen_ir_dir"]
chip_power = f"{gen_file_path}/Bearly-power"
cpf_path = f"{chip_power}/ChipTop.cpf"
rocket_cpf = f"{chip_power}/rocket.cpf"
spad_cpf = f"{chip_power}/scratchpad.cpf"
scheduler_cpf = f"{chip_power}/scheduler.cpf"
dma_cpf = f"{chip_power}/dma.cpf"
out_file_path_yaml = f"{gen_file_path}/bearly-design-gen.yml"
rocket_reserve_cpf = f"{chip_power}/rocket_reserve.cpf"


top_name = "ChipTop"

# --- DR COLLATERAL PATHING ---
# DR collateral should be collected in a better location eventually.
die_ring_gds = f"{proj_path}/packaging_collateral/uni2_2x2sub4x4_c4_er_edm_prs_top_cnr.gds"
die_ring_lef = f"{proj_path}/packaging_collateral/uni2_2x2sub4x4_c4_er_edm_prs_top_cnr.lef"
os.makedirs(gen_file_path, exist_ok=True)

# --- PACKAGING ---
package = IC.uni22_die_ring
fixed_ring_io_file = f"{proj_path}/packaging_collateral/uni2_2x2_fixed_ring.io"
bump_map = BumpMapUni22("INTEL UNI2x2PACKAGE, S22X")


# --- SOURCE FILES ---
top_module = "ChipTop"
src_list = []

# --- CLOCK ---
clk_list = [{"name": "clk", "path": "clk", "period": "0.625 ns", "uncertainty": "0.01 ns"}]

# --- PLACEMENT ---
placement_constr_list = [{"path": f"{top_name}", "type": "toplevel", "x": 0, "y": 0, "width": IC.corner_2x2_width, "height": IC.corner_2x2_height,
                          "margins": {"left": IC.uni22_left_margin, "right": IC.uni22_right_margin, "bottom": IC.uni22_bottom_margin, "top": IC.uni22_top_margin}}]

# Temporary bump assignment method.
# <Insert your own bump assignment commands/script here.>
# There is a bump floorplanning ir class coming down the pipeline.


count = 0
for bump in bearly_table:
  b = bearly_table[bump]
  if b["used"]: 
    print("[MAP-LOG]: ", count ," : {:<25} ---> Bump({}, {:>3})".format(b["name"], b["bump_x"], b["bump_y"]))
    bump_map.set_single(b["bump_x"], b["bump_y"], b["name"])
    count += 1


# --- POWER ---
# Information regarding supplies.
power_dict = {
  "vdd_def":    SupplyInfoDefinition(0.85, 0.85, voltage_nom=0.85, is_primary=True, pins=["vcc_nom"], bump_map_domain=GridDomain.VDD1, net_name="VDD", create_global_connection=True),
  "vddb_def":   SupplyInfoDefinition(1.2, 1.2, bump_map_domain=GridDomain.VDD3, net_name="VDDV"),
  "vss_def":    GroundInfoDefinition(voltage_nom=0, is_primary=True, pins=["vssp", "vssb", "vssx"], bump_map_domain=GridDomain.VSS, net_name="VSS", create_global_connection=True)
}
# Specify which of the dict are suppplies. 
supply_defs = ["vdd_def", "vddb_def"]
# Specify which of the dict are gnds.
gnd_defs    = ["vss_def"]

# If using GEN_SUPPPLIES, fill in the following list of dictionaries.
# Note that as HAMMER stands, you pick 1:1 correspondance of supply and pin.
gen_power_list = [{"name": "VDD", "pin": "VDD"}]
gen_gnd_list   = [{"name": "VSS", "pin": "VSS"}]

# ---------------------------------------------------------------------------
# UTIL CLASS
# ---------------------------------------------------------------------------
gen_util = GeneralUtil()
gen_ir = {}

# ---------------------------------------------------------------------------
# SOURCE FILES
# ---------------------------------------------------------------------------
if GEN_SRC:
  assert top_module != None or top_module != "", "Invalid top_module input." 
  
  syn_inputs_ir = {}
  syn_inputs_ir["top_module"]  = top_module
  syn_inputs_ir["input_files"] = src_list
  gen_ir.update({"synthesis.inputs_meta": "append"}) 
  gen_ir.update({"synthesis.inputs": syn_inputs_ir})
  
# ---------------------------------------------------------------------------
# CLOCKS
# ---------------------------------------------------------------------------
if GEN_CLKS:
  assert clk_list, "Clock list is empty but inclusion is specified." 
  gen_ir.update({"vlsi.inputs.clocks": clk_list})

# ---------------------------------------------------------------------------
# PLACEMENT
# ---------------------------------------------------------------------------
if GEN_DIE_RING:
  assert GEN_PLACEMENT, "Must generate placement if die ring is to be generated."
  if package == IC.uni22_die_ring:
    placement_constr_list.append({"path": f"{top_name}/die_ring", "type": "overlap", "master": IC.uni22_die_ring, "x": 0, "y": 0, "create_physical": True})

if GEN_PLACEMENT:
  gen_ir.update({"vlsi.inputs.placement_constraints": placement_constr_list})

# ---------------------------------------------------------------------------
# POWER
# ---------------------------------------------------------------------------
# Create single-domain CPF.
power_ir = {}
supply_list = [power_dict[key] for key in supply_defs]
gnd_list    = [power_dict[key] for key in gnd_defs]
rocket_supply_list = [power_dict["vdd_def"]]
spad_supply_list = [power_dict["vdd_def"]]
scheduler_supply_list = [power_dict["vdd_def"]]
dma_supply_list = [power_dict["vdd_def"]]
rocket_reserve_supply_list = [power_dict["vdd_def"]]

if GEN_CPF:
  gen_util.create_cpf(cpf_path, top_name, "PD1", "0.85", supply_list, gnd_list)
  gen_util.create_cpf(rocket_cpf, "RocketTile", "PD1", "0.85", rocket_supply_list, gnd_list)
  gen_util.create_cpf(spad_cpf, "backingscratchpad", "PD1", "0.85", spad_supply_list, gnd_list)
  gen_util.create_cpf(scheduler_cpf, "Scheduler", "PD1", "0.85", scheduler_supply_list, gnd_list)
  gen_util.create_cpf(rocket_reserve_cpf, "RocketTile_2", "PD1", "0.85", rocket_reserve_supply_list, gnd_list)
  

# Create supply definitions.
if GEN_SUPPLIES:
  primary_supply_voltage = None
  primary_ground_voltage = None
  
  for ground in gnd_list:
    if ground.is_primary: primary_ground_voltage = ground.voltage_nom
  for supply in supply_list:
    if supply.is_primary: primary_supply_voltage = supply.voltage_nom

  assert primary_supply_voltage != None and primary_ground_voltage != None, "Invalid voltages for primary VDD/GND, check if voltage_nom is specified."
    
  # Supply dictionary
  supplies_dict = {"VDD": f"{str(primary_supply_voltage)} V",
                   "GND": f"{str(primary_ground_voltage)} V"}
  supplies_dict ["power"]  = gen_power_list
  supplies_dict ["ground"] = gen_gnd_list
  power_ir.update({"vlsi.inputs.supplies": supplies_dict})
  
gen_ir.update(power_ir)

# ---------------------------------------------------------------------------
# EXTRA LIBS
# ---------------------------------------------------------------------------
if GEN_EXTRA_LIBS:
  extra_lib_list.append({"library" : 
    {"gds_file": die_ring_gds,
     "lef_file": die_ring_lef}})

gen_ir.update({"vlsi.technology.extra_libraries": extra_lib_list})
gen_ir.update({"vlsi.technology.extra_libraries_meta": "append"})

# ---------------------------------------------------------------------------
# IO File Generation (TODO)
# ---------------------------------------------------------------------------
if GEN_PAD_RING:
  gen_ir.update({"project.io_file": fixed_ring_io_file})

# ---------------------------------------------------------------------------
# BUMPS
# ---------------------------------------------------------------------------
bump_ir = {}

if GEN_BUMPS:
  # Create a domain_dict to satisfy check domains.
  domain_dict = {power_dict[key].net_name: power_dict[key].bump_map_domain for key in power_dict.keys() if power_dict[key].bump_map_domain != GridDomain.UNASSIGNED}

  # Filter through power_dict grabbing the ones relevant to bumps.
  # This is a bit convoluted but necessary for some designs.
  power_bump_dict = {key: power_dict[key] for key in power_dict.keys() if power_dict[key].bump_map_domain != GridDomain.UNASSIGNED}

  for defs in power_bump_dict.values():
    if defs.bump_map_domain != GridDomain.UNASSIGNED:
      bump_map.set_domain(defs.net_name, defs.bump_map_domain)

  bump_map.check_domains(domain_dict)
  bump_map.visualize_grid()
  bump_ir = bump_map.gen_bump_ir()
  bump_ir = {"vlsi.inputs.bumps_mode": "manual",
             "vlsi.inputs.bumps": bump_ir}
gen_ir.update(bump_ir)

# ---------------------------------------------------------------------------
# TAPEOUT CLASS SETTINGS:
# ---------------------------------------------------------------------------
tapeout_ir = {}

# Stop gmb strapping.
tapeout_ir.update({"par.generate_power_straps_options.by_tracks.strap_layers": ["m3", "m4", "m5", "m6", "m7", "m8", "gmz", "gm0"]})
tapeout_ir.update({"par.generate_power_straps_options.by_tracks.pin_layers": ["gm0"]})

gen_ir.update(tapeout_ir)


# ---------------------------------------------------------------------------
# JSON File Generation
# ---------------------------------------------------------------------------
if GEN_DESIGN_JSON:
  with open(out_file_path_yaml, 'w+') as f:
      f.write(yaml.dump(gen_ir, indent=2, sort_keys=False))
      f.close()
      print("-"* 76)
      print(ef.bold + fg(34) + "GENERATED:" +rs.fg + rs.ef + " A custom JSON based on preferences.")
      print("-"* 76)


