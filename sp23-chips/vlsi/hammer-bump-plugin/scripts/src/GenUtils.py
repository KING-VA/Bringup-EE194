#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# -------------------------------------------------------------------------
# GENERAL UTILITY 
# last Modified: 01/12/22, Ken H
# General utilities for stuff I find useful. Some functions are potentially
# not generalizable. Input is appreciated. Feel free to use (or not use)
# stuff as you go along.
# -------------------------------------------------------------------------

from typing import List, Dict, Tuple
from decimal import Decimal
from dataclasses import dataclass, field
from BumpUtils import GridDomain
from enum import Enum
import warnings
import datetime
import io

class PadEdge (Enum):
    NORTH = 1  
    SOUTH = 2
    EAST  = 3
    WEST  = 4

@dataclass
class SupplyInfoDefinition:
  voltage_low: float
  voltage_hi: float
  net_name: str = ""
  voltage_nom: float = 0
  is_primary: bool = False
  pins: List[str] = field(default_factory=list)
  bump_map_domain: GridDomain = GridDomain.UNASSIGNED
  create_global_connection: bool = False
@dataclass
class GroundInfoDefinition:
  net_name: str = ""
  voltage_nom: float = 0
  is_primary: bool = False
  pins: List[str] = field(default_factory=list)
  bump_map_domain: GridDomain = GridDomain.UNASSIGNED
  create_global_connection: bool = False

  # A multipurpose function for setting grid properties in bump.
  def set_single(self, x: int, y: int, 
                 name: str, 
                 nc: bool = False, 
                 cell: str = None) -> None:
    if self.grid[x-1][y-1].name != "":
      warnings.warn(f"A non-empty name ({self.grid[x-1][y-1].name}) exists for this bump. An assignment is being overridden by {name}!")

    self.grid[x-1][y-1].name = name
    self.grid[x-1][y-1].nc   = nc
    self.grid[x-1][y-1].cell = cell

@dataclass
class BumpFPDefinition:
  net_name: int
  bump_x: int
  bump_y: int
  pad_inst_path: str =""
  pad_edge: PadEdge = PadEdge.SOUTH
  pad_pos: int = 0

class GeneralUtil:
  def __init__(self):
    pass

  def write_header(self, header: str, wrapper: io.TextIOWrapper)->None:
    now = datetime.datetime.now()
    wrapper.write("# "+"="*39+"\n")
    wrapper.write("# "+header+"\n")
    wrapper.write(f"# CREATED AT {now} \n")
    wrapper.write("# "+"="*39+"\n")

  def create_cpf(self,
                 cpf_file_path: str, 
                 design_top: str,
                 power_domain: str,
                 nom_voltage: float,
                 supply_info: List[SupplyInfoDefinition],
                 ground_info: List[GroundInfoDefinition]) -> any:
    """
    This function is for creating cpf files. 
    :cpf_file_path: Path to write cpf file.
    :design_top:    Design top-level name.
    :power_domain:  Name for primary power domain (there should only be 1)
    :nom_voltage:   The nominal voltage for the power domain.
    :supply_info:   Dictionary of supplies with corresponding SupplyInfoDefinition.
    :ground_info:   Dictionary of grounds with corresponding SupplyInfoDefinition.
    """
    
    f = open(cpf_file_path,"w+")
    self.write_header("HAMMER-GENERATED CPF FILE", f)
    f.write("\n")

    # Set up headers
    f.write("set_cpf_version 1.1\n")
    f.write("set_hierarchy_separator /\n")
    f.write(f"set_design {design_top}\n")
    f.write("\n")
    
    # Set up the voltage nets..
    for supply in supply_info:      
      if supply.voltage_low == supply.voltage_hi :
        f.write(f"create_power_nets -nets {supply.net_name} -voltage {supply.voltage_hi}\n")
      else: 
        f.write(f"create_power_nets -nets {supply.net_name} -voltage {{{supply.voltage_low}:{supply.voltage_hi}}}\n")

    # Set up ground nets.
    combined_ground = ' '.join([ground.net_name for ground in ground_info])
    if len(ground_info) == 1:
      f.write(f"create_ground_nets -nets {combined_ground}\n")
    else:
      f.write(f"create_ground_nets -nets [list {combined_ground}]\n")

    # Set up a single domain. No point setting additional domains in current hammer.
    f.write(f"create_power_domain -name {power_domain} -default\n")
    f.write("\n")

    # Set up the power nets properly.
    primary_power_net  = ""
    primary_ground_net = ""

    for supply in supply_info:    
      if supply.is_primary: primary_power_net = supply.net_name

    for ground in ground_info:
      if ground.is_primary: primary_ground_net = ground.net_name

    assert primary_power_net  != "", "Missing primary power net!"
    assert primary_ground_net != "", "Missing primary ground net!"

    f.write(f"update_power_domain -name {power_domain} -primary_power_net {primary_power_net} -primary_ground_net {primary_ground_net}\n")
    f.write("\n")

    # Now setup the pins for the cpf.
    combined_domain_list = supply_info + ground_info
    for domain in combined_domain_list:
      combined_pins = ' '.join(domain.pins)
      if len(domain.pins) == 1 and domain.create_global_connection:
        f.write(f"create_global_connection -domain {power_domain} -net {domain.net_name} -pins {combined_pins}\n")
      elif len(domain.pins) > 1 and domain.create_global_connection:
        f.write(f"create_global_connection -domain {power_domain} -net {domain.net_name} -pins [list {combined_pins}]\n")
      else:
          warnings.warn(f"This power net ({domain.net_name}) has no pin connections. Add connections in a subsequent hammer hook.")
    if design_top == "ChipTop":
      f.write(f"create_global_connection -domain {power_domain} -net VDDV -pins vccldo_hv \n")
    
    f.write("\n")

    # Create a nominal condition for the cpf.
    f.write(f"create_nominal_condition -name normal -voltage {nom_voltage}\n")
    f.write(f"create_power_mode -name {power_domain} -default -domain_conditions {{{power_domain}@normal}}\n")
    
    f.write("end_design\n")
    f.close()  
