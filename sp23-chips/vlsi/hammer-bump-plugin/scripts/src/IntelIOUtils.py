#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# -------------------------------------------------------------------------
# Intel IO Utility
# last Modified: 01/14/22, Ken H
# Generates 
# -------------------------------------------------------------------------

from enum import Enum   
from IOUtils import IOUtil
from abc import ABC, abstractproperty, abstractmethod
import IntelConstants as IC

class IntelIOUtil (IOUtil):
  def __init__(self):
    pass
  
  @property
  def grid_x_size(self):
    return IC.uni22_grid_x_size

  @property
  def grid_y_size(self):
    return IC.uni22_grid_y_size

  @property
  def filler_width_x(self):
    return IC.n_filler

  @property
  def filler_width_y(self):
    return IC.e_filler

  @property
  def sdio_width_x(self):
    pass

  @property
  def sdio_width_y(self):
    pass

  @property
  def pitch_x(self):
    return IC.uni22_pitch_x

  @property
  def pitch_y(self):
    return IC.uni22_pitch_y
  
  # This creates a horizontal area IO at a specified bump location.
  # This area IO will squeeze between bump rows and assign accordingly.
  #    X   X  
  # [][][][]  
  # X   X

  @abstractmethod  
  def create_horizonal_area_io(self, complete=False)->None:
    """
    params complete: Get a clean area-io pad setup with terminators.
    """    
    
    

