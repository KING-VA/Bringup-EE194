"""
This script is used to generate the pointers to the stdcell libraries.
The output should be pasted into intech22.tech.json.
"""

import os
import json

# PDK path
lib_prefix = "lib224_b15_7t_108pp"
pdk = f"/tools/intech22/LIB/{lib_prefix}_pdk090_r1v0p0_fv"
# Device variants
vts = ["ulvt", "lvt", "lplvt", "hp", "nom", "lp", "ulp"]
# Logic families
families = ["base", "dsseq", "lvl", "pwm", "seq", "spcl"]
# Desired PVTs order: [setup, hold, typ power, EM/IR]
processes = ["psss", "pfff", "tttt", "tttt"]
ext_corners = ["pcss", "pcff", "tttt", "tttt"]
voltages = ["0p765v", "0p890v", "0p850v", "0p890v"]
temps = ["125c", "m40c", "25c", "105c"]

# Generate
libraries = []
for vt in vts:
    for family in families:
        if family == "lvl": # Level shifters: not yet implemented
            continue
        else:
            for (i, corner) in enumerate(["slow", "fast", "typical"]):

                library = {
                  "nldm_liberty_file": f"$STDCELLS/{family}_{vt}/lib/{lib_prefix}_{family}_{vt}_{processes[i]}_{voltages[i]}_{temps[i]}_tttt_ctyp_nldm.lib.gz",
                  "ccs_liberty_file": f"$STDCELLS/{family}_{vt}/lib/{lib_prefix}_{family}_{vt}_{processes[i]}_{voltages[i]}_{temps[i]}_tttt_ctyp_ccslnt.lib.gz",
                  "verilog_sim": f"$STDCELLS/{family}_{vt}/verilog/{lib_prefix}_{family}_{vt}.v",
                  "milkyway_lib_in_dir": f"$STDCELLS/{family}_{vt}/fram/{lib_prefix}_{family}_{vt}",
                  "gds_file": f"$STDCELLS/{family}_{vt}/gds/{lib_prefix}_{family}_{vt}.gds",
                  "lef_file": f"$STDCELLS/{family}_{vt}/lef/{lib_prefix}_{family}_{vt}.lef",
                  "spice_file": f"$STDCELLS/{family}_{vt}/cdl/{lib_prefix}_{family}_{vt}.cdl",
                  "qrc_techfile": f"$PDK/extraction/qrc/techfiles/m11_1x_3xa_1xb_1xc_2yb_2ga_mim2_1gb__bumpp/{ext_corners[i]}/qrcTechFile",
                  "spice_model_file": {
                    "path": "$PDK/models/core/spectre/m11_1x_3xa_1xb_1xc_2yb_2ga_mim2_1gb__bumpp/p1222_4.scs",
                    "lib_corner": ext_corners[i].replace('p','r')
                  },
                  "power_grid_library": f"$STDCELLS/{family}_{vt}/pgv/{lib_prefix}_{family}_{vt}_{processes[-1]}_{voltages[-1]}_{temps[-1]}_tttt_ctyp_stdcells.cl",
                  "corner": {
                    "nmos": corner,
                    "pmos": corner,
                    "temperature": temps[i].replace('m','-').replace('c',' C')
                  },
                  "supplies": {
                    "VDD": voltages[i].replace('p','.').replace('v',' V'),
                    "GND": "0 V"
                  },
                  "provides": [
                    {
                      "lib_type": "stdcell",
                      "vt": vt
                    }
                  ]
                }
                libraries.append(library)

# Write
out = open('intech22_stdcells.json', 'w')
json.dump({"libraries": libraries}, out, indent=2)
