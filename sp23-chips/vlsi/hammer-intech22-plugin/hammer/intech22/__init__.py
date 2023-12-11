#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
#  intech22 plugin for Hammer.
#
#  See LICENSE for licence details.

import sys
import re
import os
import textwrap
import tempfile
import shutil
from typing import NamedTuple, List, Optional, Tuple, Dict, Set, Any
from decimal import Decimal

from hammer.tech import HammerTechnology
from hammer.vlsi import HammerTool, HammerDRCTool, MentorCalibreTool, HammerToolHookAction

intech22_innovus = __import__('hammer.intech22.par.innovus', fromlist=['*'])
intech22_calibre_drc = __import__('hammer.intech22.drc.calibre', fromlist=['*'])

class INTECH22Tech(HammerTechnology):
    """
    Override the HammerTechnology used in `hammer_tech.py`
    This class is loaded by function `load_from_json`, and will pass the `try` in `importlib`.
    """
    def post_install_script(self) -> None:
        self.logger.info("Copy pad filler LEF into tech cache, change class to PAD SPACER")
        pads_dir = self.get_setting("technology.intech22.pad_install_dir")
        for lef in ["ip224_basic/physical/lef/spacer_2lego_e1.lef", "ip224_basic/physical/lef/spacer_2lego_n1.lef"]:
            os.makedirs(os.path.dirname(os.path.join(self.cache_dir, lef)), exist_ok=True)
            with open(os.path.join(pads_dir, lef)) as infile, open(os.path.join(self.cache_dir, lef), 'w+') as outfile:
                outfile.write(infile.read().replace('AREAIO', 'SPACER'))

        self.logger.info("Add DIEAREA layer to tech LEF: boundary layer needed for DRC")
        base_dir = self.get_setting("technology.intech22.pdk_install_dir")
        lef = "apr/cadence/m11_1x_3xa_1xb_1xc_2yb_2ga_mim2_1gb__bumpp/7t108_tp0/p1222.lef"
        os.makedirs(os.path.dirname(os.path.join(self.cache_dir, lef)), exist_ok=True)
        with open(os.path.join(base_dir, lef), encoding="utf-8") as infile, open(os.path.join(self.cache_dir, "p1222.lef"), 'w+', encoding="utf-8") as outfile:
            outfile.write(infile.read()
                    .replace('LAYER OVERLAP', 'LAYER DIEAREA\n TYPE MASTERSLICE ;\nEND DIEAREA\n\nLAYER OVERLAP')
                )

        self.logger.info("Copy GDS map file into tech cache, GLOBALFILLKOR layer to SPNETS") # so we can use create_shape
        pdk_dir = self.get_setting("technology.intech22.pdk_install_dir")
        gds_map = "apr/cadence/m11_1x_3xa_1xb_1xc_2yb_2ga_mim2_1gb__bumpp/7t108_tp0/p1222.cdns_gds.map"
        os.makedirs(os.path.dirname(os.path.join(self.cache_dir, gds_map)), exist_ok=True)
        with open(os.path.join(pdk_dir, gds_map)) as infile, open(os.path.join(self.cache_dir, os.path.basename(gds_map)), 'w+') as outfile:
            outfile.write(infile.read().replace('GLOBALFILLKOR CUSTOM', 'GLOBALFILLKOR SPNET'))

    def get_tech_par_hooks(self, tool_name: str) -> List[HammerToolHookAction]:
        hooks = {"innovus": [
            HammerTool.make_persistent_hook(intech22_innovus.intech22_pre_db),
            HammerTool.make_post_persistent_hook("init_design", intech22_innovus.intech22_innovus_settings),
            HammerTool.make_post_insertion_hook("floorplan_design", intech22_innovus.intech22_create_sites),
            HammerTool.make_replacement_hook("place_tap_cells", intech22_innovus.intech22_tap_cells),
            #HammerTool.make_replacement_hook("power_straps", intech22_innovus.intech22_reference_power_straps),
            HammerTool.make_post_insertion_hook("power_straps", intech22_innovus.intech22_m2_staples),
            HammerTool.make_pre_insertion_hook("clock_tree", intech22_innovus.intech22_cts_options),
            HammerTool.make_replacement_hook("add_fillers", intech22_innovus.intech22_add_fillers),
            HammerTool.make_pre_insertion_hook("write_design", intech22_innovus.intech22_extra_layers)
            ]}
        return hooks.get(tool_name, [])

    def get_tech_drc_hooks(self, tool_name: str) -> List[HammerToolHookAction]:
        hooks = {"calibre": [
            HammerTool.make_replacement_hook("generate_drc_run_file", intech22_calibre_drc.intech22_drc_run_file)
            ]}
        return hooks.get(tool_name, [])

tech = INTECH22Tech()
