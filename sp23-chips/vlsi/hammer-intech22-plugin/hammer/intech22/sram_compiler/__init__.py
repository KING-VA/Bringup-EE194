
import os, tempfile, subprocess

from hammer.vlsi import MMMCCorner, MMMCCornerType, HammerTool, HammerToolStep, HammerSRAMGeneratorTool, SRAMParameters
from hammer.vlsi.units import VoltageValue, TemperatureValue
from hammer.tech import Library, ExtraLibrary
from typing import NamedTuple, Dict, Any, List
from abc import ABCMeta, abstractmethod

class INTECH22SRAMGenerator(HammerSRAMGeneratorTool):
    def tool_config_prefix(self) -> str:
        return "sram_generator.intech22"

    def version_number(self, version: str) -> int:
        return 0

    # Run generator for a single sram and corner
    def generate_sram(self, params: SRAMParameters, corner: MMMCCorner) -> ExtraLibrary:
        tech_cache_dir = os.path.abspath(self.technology.cache_dir)
        intech22_cache_dir=self.get_setting("technology.intech22.sram_cache_dir")

        if(params.family == "1rw"):
            fam_code = "uhdlp1p11rf_"
            fam_block = "b2c1s1"  if params.mask else "b2c1s0"
            fam_suffix = "_t0r0p0d0a1m1h"
            fam_mask = ""
        elif(params.family == "1r1w"):
            fam_code = "rfsbhpm1r1w"
            fam_block = ""
            fam_suffix = ""
            fam_mask = "be{w}".format(w=params.width) if params.mask else ""
        else:
            self.logger.error("INTECH22 SRAM cache does not support family:{f}".format(f=params.family))

        #TODO: this is really an abuse of the corner stuff
        #TODO: when we have matching corners remove real_corner and symlink junk
        if(corner.type == MMMCCornerType.Setup):
            speed = "psss"
            speed_name = "slow"
            real_corner = "psss_0.765v_125c"
        elif(corner.type == MMMCCornerType.Hold):
            speed = "pfff"
            speed_name = "fast"
            real_corner = "pfff_0.89v_-40c"
        elif(corner.type == MMMCCornerType.Extra):
            speed = "tttt"
            speed_name = "typical"
            real_corner = "tttt_0.85v_25c"
        corner_str = "{speed}_{volt}v_{temp}c".format(
                speed=speed,
                volt = str(corner.voltage.value_in_units("V")).replace(".","p"),
                temp = str(int(corner.temp.value_in_units("C"))).replace(".","p"))

        sram_name = "ip224{fc}{d}x{w}{fm}m{m}{fb}{fs}".format(
                fc=fam_code, fb=fam_block, fs=fam_suffix, fm=fam_mask,
                d=params.depth,w=params.width,m=params.mux,
                ver="100a")

        # path to cached lib
        cache_lib_path = "{t}/{n}_{c}.lib".format(t=tech_cache_dir,n=sram_name,c=corner_str)

        # path to intel lib
        base_dir = "{c}/{sn}".format(
                c=intech22_cache_dir, sn=sram_name)
        intel_lib_path = "{b}/timing/{n}_{rc}.lib".format(b=base_dir,n=sram_name,rc=real_corner)

        if not os.path.exists(intel_lib_path):
            intel_lib_path = "{b}/lib/{n}_{rc}.lib".format(b=base_dir,n=sram_name,rc=real_corner)

        if not os.path.exists(cache_lib_path):
            os.symlink(intel_lib_path,cache_lib_path)

        lef_path = "{b}/physical/lef/{n}.lef".format(b=base_dir,n=sram_name)
        if not os.path.exists(lef_path):
            lef_path = "{b}/lef/{n}.lef".format(b=base_dir,n=sram_name)

        gds_path = "{b}/physical/gds/{n}.stm".format(b=base_dir,n=sram_name)
        if not os.path.exists(gds_path):
            gds_path = "{b}/gds/{n}.stm".format(b=base_dir,n=sram_name)
            if not os.path.exists(gds_path):
                gds_path = "{b}/physical/gds/{n}.gds".format(b=base_dir,n=sram_name)

        spice_path = "{b}/physical/sp/{n}.sp".format(b=base_dir,n=sram_name)
        if not os.path.exists(spice_path):
            spice_path = "{b}/spice/{n}.sp".format(b=base_dir,n=sram_name)

        for path in [intel_lib_path, lef_path, gds_path, spice_path]:
            assert(os.path.exists(path), "Required file {} is missing".format(path))

        lib = ExtraLibrary(prefix=None, library=Library(
                name=sram_name,
                nldm_liberty_file="{t}/{n}_{c}.lib".format(t=tech_cache_dir,n=sram_name,c=corner_str),
                lef_file=lef_path,
                gds_file=gds_path,
                spice_file=spice_path,
                verilog_sim="{b}/rtl/{n}.sv".format(b=base_dir,n=sram_name),
                corner = {'nmos': speed_name, 'pmos': speed_name, 'temperature': str(corner.temp.value_in_units("C")) +" C"},
                supplies = {'VDD': str(corner.voltage.value_in_units("V")) + " V", 'GND': "0 V" },
                provides = [{'lib_type': "sram", 'vt': params.vt}]))
        return lib

tool=INTECH22SRAMGenerator
