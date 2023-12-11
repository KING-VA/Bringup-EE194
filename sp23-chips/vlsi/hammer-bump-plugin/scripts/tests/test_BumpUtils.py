#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# --------------------------------
# Tests for Bump Utility
# last Modified: 01/01/22, Ken H
# --------------------------------

from scripts.src.BumpUtils import BumpMap, GridDomain, BumpMapTest
import warnings

def test_bump_setters():
  bump_map = BumpMapTest("TEST PACKAGE")
  
  # Test domains.
  assert bump_map.grid[0][1].domain == GridDomain.VDD1
  assert bump_map.grid[0][3].domain == GridDomain.VDD1
  assert bump_map.grid[1][2].domain == GridDomain.VSS
  assert bump_map.grid[2][1].domain == GridDomain.LSIO
  assert bump_map.grid[2][3].domain == GridDomain.LSIO
  assert bump_map.grid[3][0].domain == GridDomain.HSIO
  assert bump_map.grid[3][2].domain == GridDomain.HSIO
  assert bump_map.grid[1][0].domain == GridDomain.HSIO

  # Test set_single.
  bump_map.set_single(1, 2, "VDDH", nc=True, cell="FAKEBUMP")
  assert bump_map.grid[0][1].x == 0
  assert bump_map.grid[0][1].y == 1
  assert bump_map.grid[0][1].name == "VDDH"
  assert bump_map.grid[0][1].nc   == True
  assert bump_map.grid[0][1].cell == "FAKEBUMP"

  # Test set_col.
  bump_map.set_col(1, 2, length=2, name="VDD_ANA")
  assert bump_map.grid[0][1].name == "VDD_ANA"
  assert bump_map.grid[0][3].name == "VDD_ANA"

  # Test set_col.
  bump_map.set_row(2, 1, length=2, name="HS_SIG")
  assert bump_map.grid[1][0].name == "HS_SIG"
  assert bump_map.grid[3][0].name == "HS_SIG"
  
  # Test set_domain.
  bump_map.set_domain("VDDQ", GridDomain.VDD1)
  assert bump_map.grid[0][1].name == "VDDQ"
  assert bump_map.grid[0][3].name == "VDDQ"

def test_checking_functions():
  bump_map = BumpMapTest("TEST PACKAGE")
  bump_map.set_single(1, 2, "VDDH")
  bump_map.set_single(1, 4, "VDDQ")
  
  # Make sure checking domains is working.
  # Set warning catching to ignore.
  with warnings.catch_warnings():
    warnings.simplefilter("ignore")
    bump_map.check_domains({"VDDH": GridDomain.VDD1})

  # See if multiple domain checking works.
  bump_map.set_single(1, 4, "VDDH")
  bump_map.set_single(2, 3, "VSS1")
  bump_map.check_domains({"VDDH": GridDomain.VDD1, "VSS1": GridDomain.VSS})

def test_ir_return():
  bump_map = BumpMapTest("TEST PACKAGE")
  bump_map.set_domain("VDDQ",   GridDomain.VDD1)
  bump_map.set_domain("VSS",    GridDomain.VSS)
  bump_map.set_domain("LS_SIG", GridDomain.LSIO)
  bump_map.set_domain("HS_SIG", GridDomain.HSIO)
  bump_ir = bump_map.gen_bump_ir()
  assert bump_ir['x'] == 4
  assert bump_ir['y'] == 4
  assert bump_ir['global_x_offset'] == 0
  assert bump_ir['global_x_offset'] == 0
  assert bump_ir['pitch_x'] == float(1)
  assert bump_ir['pitch_y'] == float(1)
  assert bump_ir['cell'] == "TEST_CELL"
  assert len(bump_ir['assignments']) == 8
