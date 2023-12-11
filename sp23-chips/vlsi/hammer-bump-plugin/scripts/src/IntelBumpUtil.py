#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# --------------------------------
# Intel Bump Map
# last Modified: 01/01/22, Ken H
# --------------------------------

from BumpUtils import BumpMap, GridDomain
import IntelConstants as IC

class BumpMapUni22 (BumpMap):
  @property
  def incr(self):
    return 2
  
  @property
  def grid_x_size(self):
    return IC.uni22_grid_x_size
  
  @property
  def grid_y_size(self):
    return IC.uni22_grid_y_size

  @property
  def global_x_offset(self):
    return IC.uni22_global_x_offset
  
  @property
  def global_y_offset(self):
    return IC.uni22_global_y_offset

  @property
  def pitch_x(self):
    return IC.uni22_pitch_x

  @property
  def pitch_y(self):
    return IC.uni22_pitch_y

  @property
  def bump_cell(self):
    return IC.bump_cell

  @property
  def domains(self):
    domains = {}
    # Set VDD1
    coords = []
    for x in range(7, 24, 2):
      for y in range(10, 25, 2):
        coords.append((x,y))
    domains [GridDomain.VDD1] = coords
    
    # Set VDD2
    coords = []
    for x in range(4, 24, 2):
      coords.append((x, 5))
    coords.append((0,5))
    domains [GridDomain.VDD2] = coords

    # Set VDD3
    coords = []
    for y in range(6, 25, 2):
        coords.append((5, y))
    domains [GridDomain.VDD3] = coords

    # Set VSS
    coords = []
    for x in range(6, 24, 2):
      for y in range(11, 25, 2):
        coords.append((x ,y))
    for y in range(1, 25, 2):
        coords.append((2, y))
    for x in range(1, 24, 2):
        coords.append((x, 4))
    coords.extend([(1,6), (3,6)])
    domains [GridDomain.VSS] = coords

    # Set HSIO
    coords = []
    for y in range(7, 25, 2): coords.append((0, y))
    for y in range(8, 25, 2): coords.append((1, y))
    for y in range(8, 25, 2): coords.append((3, y))
    for y in range(7, 25, 2): coords.append((4, y))
    domains [GridDomain.HSIO] = coords

    # Set LSIO
    coords = []
    for x in range(3, 24, 2): coords.append((x, 0))
    for x in range(4, 24, 2): coords.append((x, 1))
    for x in range(3, 24, 2): coords.append((x, 2))
    for x in range(4, 24, 2): coords.append((x, 3))
    for x in range(7, 24, 2): coords.append((x, 6))
    for x in range(6, 24, 2): coords.append((x, 7))
    for x in range(7, 24, 2): coords.append((x, 8))
    for x in range(6, 24, 2): coords.append((x, 9))
    coords.extend([(0,1), (0,3), (1,0), (1,2)])
    domains [GridDomain.LSIO] = coords

    return domains