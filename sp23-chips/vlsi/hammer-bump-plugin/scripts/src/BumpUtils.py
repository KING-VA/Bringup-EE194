#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# -------------------------------------------------------------------------
# BUMP UTILITY 
# last Modified: 01/01/22, Ken H
# Convenience classes that allow users to fill out bumps programatically.
# Note that manual offset was introduced to fix UNI1 8snf22 packaging, but
# is only supported on nov22_tapeout hammer branch. It is not required in 
# UNI2. 
# -------------------------------------------------------------------------

from typing import List, Dict
from abc import ABC, abstractproperty
from decimal import Decimal
from enum import Enum
from sty import bg, fg, ef, rs
import warnings

class BumpScheme(Enum):
    ALT_OFF = 1  # "Alternating" rows, 0th row offset.

class GridDomain (Enum):
    UNASSIGNED = 1  # Represents unassigned logical grid locations (not empty)
    EMPTY = 2       # Represents empty logical grid locations (e.g., alternating) 
    VSS   = 3
    LSIO  = 4
    HSIO  = 5
    VDD1  = 6
    VDD2  = 7
    VDD3  = 8

class Bump:
  def __init__(self, 
               x: int, y: int, 
               name: str = "",
               domain: GridDomain = GridDomain.UNASSIGNED, 
               man_x_offset: Decimal = 0, 
               man_y_offset: Decimal = 0,
               nc: bool = False,
               cell: str = None):
    """
    General bump instance.
    :x: Logical X-coordinate.
    :y: Logical Y-coordinate.
    :name: Bump net name.
    :domain: The domain that the bump is assigned to.
    :man_x_offset: A manual physical X-offset.
    :man_y_offset: A manual physical Y-offset.
    """
    self.x = x
    self.y = y 
    self.name = name
    self.domain = domain
    self.man_x_offset = man_x_offset
    self.man_y_offset = man_y_offset
    self.nc = nc
    self.cell = cell
      
class BumpMap (ABC):
  def __init__(self, 
               map_name: str,
               bump_scheme: BumpScheme = BumpScheme.ALT_OFF,
               man_x_offset_list: List[Decimal] = [],
               man_y_offset_list: List[Decimal] = []):
    """
    Captures the bump scheme. Internally, the map indexes from 0. 
    However, when translated into json, indexing begins from 1 to match Hammer.
    
    :map_name: Name.
    :bump_scheme: Describes bump scheme.
    :man_x_offset_list: Describes manual x offsets. 
    :man_y_offset_list: Describes manual y offsets.
    """
    self.map_name    = map_name
    self.bump_scheme = bump_scheme
    self.man_x_offset_list = man_x_offset_list
    self.man_y_offset_list = man_y_offset_list
    self.grid= []
    
    assert self.grid_x_size > 0 and self.grid_y_size > 0, "Need a non-zero logical-grid size."
    
    if self.bump_scheme == BumpScheme.ALT_OFF:
      for y in range(self.grid_y_size): 
        row = []
        y_offset = self.parse_man_offset(y, man_y_offset_list)
        empty_x = 0 if y % 2 == 0 else 1
        for x in range(self.grid_x_size):
          x_offset = self.parse_man_offset(x, man_x_offset_list)
          if x % 2 == empty_x: 
            domain = GridDomain.EMPTY
          else:
            domain = GridDomain.UNASSIGNED
          row.append(Bump(x, y, domain = domain, man_x_offset = x_offset, man_y_offset = y_offset))
        self.grid.append(row)  
    
    # Transpose so that indexing grid corresponds to x,y and not y,x.
    self.grid = list(map(list, zip(*self.grid)))
    self.init_domains()
  
  @abstractproperty 
  def domains(self):
    pass

  @abstractproperty 
  def incr(self):
    pass

  @abstractproperty 
  def grid_x_size(self):
    pass
  
  @abstractproperty 
  def grid_y_size(self):
    pass

  @abstractproperty 
  def global_x_offset(self):
    pass
  
  @abstractproperty 
  def global_y_offset(self):
    pass

  @abstractproperty 
  def pitch_x(self):
    pass

  @abstractproperty 
  def pitch_y(self):
    pass


  @abstractproperty 
  def bump_cell(self):
    pass
  
  def parse_man_offset(self, logical_index: int, man_offset: List[Decimal]) -> Decimal:
    offset = Decimal(0) if not man_offset else man_offset(logical_index)
    return offset

  def init_domains(self) -> None:
    assert len(self.domains) > 0, "Domain must be none-empty."
    for domain, bumps in self.domains.items():
      for coordinates in bumps:
        self.grid[coordinates[0]][coordinates[1]].domain = domain
        
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
    
  def set_row(self, x: int, y: int, 
              length: int, 
              name: str, 
              nc: bool = False, 
              cell: str = None) -> None:
    
    assert length > 0, "Need a length larger than 0."
    for offset in range(length):
      x_new = x + offset*self.incr
      self.set_single(x_new, y, name=name, nc=nc, cell=cell)

  def set_col(self, x: int, y: int, length: int, 
              name: str, 
              nc: bool = False, 
              cell: str  = None) -> None:

    assert length > 0, "Need a length larger than 0."
    for offset in range(length):
      y_new = y + offset*self.incr
      self.set_single(x, y_new, name=name, nc=nc, cell=cell)
      
  def set_domain(self, name: str, domain: GridDomain, nc: bool = False, cell:str = None) -> None:
    bumps = self.domains[domain]
    for coordinates in bumps: 
      self.set_single(coordinates[0]+1, coordinates[1]+1, name=name, nc=nc, cell=cell) # Add one because set_single operates on indexing starting at 1
          
  def check_domains(self, domains: Dict[str, GridDomain]) -> None:
    warning = False
    for net_name, domain in domains.items():
      bumps = self.domains[domain]
      for coordinates in bumps: 
        if self.grid[coordinates[0]][coordinates[1]].name != net_name:
          warnings.warn(f"Bump at coord: {coordinates} correspond to target net_name. A short may exist.")
          warning = True
    if not warning:
      print("-"* 76)
      print(ef.bold + fg(39) + "SUCESSS: " + rs.fg + rs.ef + "Domains are not shorted. Check LVS for final signoff.")
      print("-"* 76)

  # Function to check that domains were assigned to the bump map properly.  
  def visualize_grid(self) -> None:
    print("-"* 76)
    print(ef.bold + "IO DOMAIN VISUALIZATION: " + fg(27) + f"{self.map_name}" + rs.fg + rs.ef)
    form_str_list=[]
    unassigned = False
    for y in range(self.grid_y_size): 
      form_str = ef.bold + ''
      for x in range(self.grid_x_size):
        bg_set = None
        if self.grid[x][y].domain == GridDomain.UNASSIGNED: 
          bg_set = bg(196) 
          unassigned = True
        elif self.grid[x][y].domain == GridDomain.EMPTY: bg_set = bg(232) 
        elif self.grid[x][y].domain == GridDomain.VSS:   bg_set = bg(235) 
        elif self.grid[x][y].domain == GridDomain.LSIO:  bg_set = bg(239) 
        elif self.grid[x][y].domain == GridDomain.HSIO:  bg_set = bg(243) 
        elif self.grid[x][y].domain == GridDomain.VDD1:  bg_set = bg(236) 
        elif self.grid[x][y].domain == GridDomain.VDD2:  bg_set = bg(254) 
        elif self.grid[x][y].domain == GridDomain.VDD3:  bg_set = bg(249)         
        if x == 0:
          if y < 9: form_str = form_str + bg(232) + f"  {y+1} " + rs.bg
          else: form_str = form_str + bg(232) + f" {y+1} " + rs.bg
        if self.grid[x][y].name == "" and self.grid[x][y].domain != GridDomain.EMPTY: 
          form_str = form_str + bg_set + ' U ' + rs.bg
        else:
          form_str = form_str + bg_set + '   ' + rs.bg
      form_str = form_str  
      form_str_list.append(form_str)
    if unassigned:
      print(ef.bold + fg(196) + "RED IO CELLS " + rs.fg + "are not mapped to domains and must be fixed." + rs.ef)
    else:
      print(ef.bold + fg(39) + "SUCESSS:" +rs.fg + rs.ef + " A bump map with complete domains was generated.")
      print("         Package fingerprint available below.")
    print("-"* 76)
    form_str_list.reverse()
    for element in form_str_list: print(element)
    axis_str = bg(232) + "    "
    for i in range(self.grid_x_size):
      if i < 9: axis_str = axis_str + f" {i+1} "
      else: axis_str = axis_str + f"{i+1} "
    axis_str = axis_str + rs.bg + rs.fg + rs.ef
    print(axis_str)    
    assert unassigned == False
  
  def gen_bump_ir(self) -> Dict[any, any]:
    bump_ir = {'x': self.grid_x_size,
               'y': self.grid_y_size,
               'global_x_offset': self.global_x_offset,
               'global_y_offset': self.global_y_offset,
               'pitch_x': float(self.pitch_x),
               'pitch_y': float(self.pitch_y),
               'cell': self.bump_cell,
               'assignments': []}
    
    bump_list = []
    for y in range(self.grid_y_size): 
      for x in range(self.grid_x_size):
        bump = self.grid[x][y]
        if bump.name:
          bump_list.append(
            {'name': bump.name, 
             'x': bump.x + 1,  # Necessary because x-indexing starts at 1
             'y': bump.y + 1,  # Necessary because y-indexing starts at 1
             'no_connect':  bump.nc, 
             'custom_cell': bump.cell})
        else:
          if bump.domain != GridDomain.EMPTY:
            bump_list.append(
              {'name': bump.name, 
               'x': bump.x + 1, 
               'y': bump.y + 1, 
               'no_connect':  True, 
               'custom_cell': bump.cell})

    bump_ir['assignments'] = bump_list
    return bump_ir
    
# An example bump map for testing.
class BumpMapTest (BumpMap):
  @property
  def incr(self):
    return 2
  
  @property
  def grid_x_size(self):
    return 4
  
  @property
  def grid_y_size(self):
    return 4

  @property
  def global_x_offset(self):
    return 0
  
  @property
  def global_y_offset(self):
    return 0

  @property
  def bump_cell(self):
    return "TEST_CELL"

  @property
  def pitch_x(self):
    return 1

  @property
  def pitch_y(self):
    return 1

  @property
  def domains(self):
    domains = {}
    # Set VDD1
    domains [GridDomain.VDD1] = [(0,1), (0,3)]
    domains [GridDomain.VSS]  = [(1,2)]
    domains [GridDomain.LSIO] = [(2,1), (2,3)]
    domains [GridDomain.HSIO] = [(3,0), (1,0), (3,2)]
    return domains