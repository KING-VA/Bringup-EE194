#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# -------------------------------------------------------------------------
# IO UTILITY
# last Modified: 01/14/22, Ken H
# An IO design tool that is meant to programmatically fill create an IO 
# ring rapidly. 
# -------------------------------------------------------------------------

from enum import Enum   
from abc import ABC, abstractproperty, abstractmethod

class IOUtil (ABC):
  def __init__(self):
    pass

  @abstractproperty 
  def grid_x_size(self):
    pass
  
  @abstractproperty 
  def grid_y_size(self):
    pass

  @abstractproperty 
  def filler_width_x(self):
    pass

  @abstractproperty 
  def filler_width_y(self):
    pass
  
  @abstractproperty 
  def sdio_width_x(self):
    pass

  @abstractproperty 
  def sdio_width_y(self):
    pass

  @abstractproperty 
  def pitch_x(self):
    pass

  @abstractproperty 
  def pitch_y(self):
    pass
  
  @abstractmethod
  def create_horizonal_area_io(self)->None:
    pass

