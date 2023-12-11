#!/usr/bin/env python3

import sys
import os
import re

if len(sys.argv) != 3:
    print("Usage: ./sram-cache-gen.py list-of-srams-1-per-line.txt output-file.json")
    exit(1)

list_of_srams = []
with open(sys.argv[1]) as f:
    for line in f:
        list_of_srams.append(line)

print(str(len(list_of_srams)) + " SRAMs read")

json = []

for sram_name in list_of_srams:
    if sram_name.startswith("ip224rf"):
        m = re.match("ip224rfsbhpm1r1w(\d+)x(\d+)be(\d+)m(\d+)", sram_name)
        if m:
            json.append("""
{{
  "type" : "sram",
  "name" : "{n}",
  "vt" : "HVT",
  "depth" : "{d}",
  "width" : {w},
  "mux" : {m},
  "family" : "1r1w",
  "ports" : [ {{
    "address port name" : "iarp0",
    "address port polarity" : "active high",
    "clock port name" : "ickrp0",
    "clock port polarity" : "positive edge",
    "read enable port name" : "irenp0",
    "read enable port polarity" : "active high",
    "output port name" : "odoutp0",
    "output port polarity" : "active high"
  }}, {{
    "address port name" : "iawp0",
    "address port polarity" : "active high",
    "clock port name" : "ickwp0",
    "clock port polarity" : "positive edge",
    "write enable port name" : "iwenp0",
    "write enable port polarity" : "active high",
    "input port name" : "idinp0",
    "input port polarity" : "active high",
    "mask port name" : "ibwep0",
    "mask port polarity" : "active high",
    "mask granularity" : 1
  }} ],
  "extra ports" : [ {{
    "name" : "ifuse",
    "width" : 1,
    "type" : "constant",
    "value" : 0
  }}, {{
    "name" : "iclkbyp",
    "width" : 1,
    "type" : "constant",
    "value" : 0
  }}, {{
    "name" : "imce",
    "width" : 1,
    "type" : "constant",
    "value" : 0
  }}, {{
    "name" : "irmce",
    "width" : 2,
    "type" : "constant",
    "value" : 0
  }}, {{
    "name" : "iwmce",
    "width" : 4,
    "type" : "constant",
    "value" : 0
  }} ]
}}
  """.format(n=sram_name.strip(), d=m.group(1), w=m.group(2), m=m.group(4)))
        else:
            m = re.match("ip224rfsbhpm1r1w(\d+)x(\d+)m(\d+)", sram_name)
            if m:
                json.append("""
{{
  "type" : "sram",
  "name" : "{n}",
  "vt" : "HVT",
  "depth" : "{d}",
  "width" : {w},
  "mux" : {m},
  "family" : "1r1w",
  "ports" : [ {{
    "address port name" : "iarp0",
    "address port polarity" : "active high",
    "clock port name" : "ickrp0",
    "clock port polarity" : "positive edge",
    "read enable port name" : "irenp0",
    "read enable port polarity" : "active high",
    "output port name" : "odoutp0",
    "output port polarity" : "active high"
  }}, {{
    "address port name" : "iawp0",
    "address port polarity" : "active high",
    "clock port name" : "ickwp0",
    "clock port polarity" : "positive edge",
    "write enable port name" : "iwenp0",
    "write enable port polarity" : "active high",
    "input port name" : "idinp0",
    "input port polarity" : "active high"
  }} ],
  "extra ports" : [ {{
    "name" : "ifuse",
    "width" : 1,
    "type" : "constant",
    "value" : 0
  }}, {{
    "name" : "iclkbyp",
    "width" : 1,
    "type" : "constant",
    "value" : 0
  }}, {{
    "name" : "imce",
    "width" : 1,
    "type" : "constant",
    "value" : 0
  }}, {{
    "name" : "irmce",
    "width" : 2,
    "type" : "constant",
    "value" : 0
  }}, {{
    "name" : "iwmce",
    "width" : 4,
    "type" : "constant",
    "value" : 0
  }} ]
}}
    """.format(n=sram_name.strip(), d=m.group(1), w=m.group(2), m=m.group(3)))
            else:
                print("Unsupported memory: {n}".format(n=sram_name))

    elif sram_name.startswith("ip224uhd"):
        m = re.match("ip224uhdlp1p11rf_(\d+)x(\d+)m(\d+)b2c1s(\d)_t0r0p0d0a1m1h", sram_name)
        if m:
            json.append("""
{{
  "type" : "sram",
  "name" : "{n}",
  "vt" : "HVT",
  "depth" : "{d}",
  "width" : {w},
  "mux" : {m},
  "family" : "1rw",
  "ports" : [ {{
    "address port name" : "adr",
    "address port polarity" : "active high",
    "clock port name" : "clk",
    "clock port polarity" : "positive edge",
    "write enable port name" : "wen",
    "write enable port polarity" : "active high",
    "read enable port name" : "ren",
    "read enable port polarity" : "active high",
    "output port name" : "q",
    "output port polarity" : "active high",
    "input port name" : "din",
    "input port polarity" : "active high"
    {mask_port}
  }} ],
  "extra ports" : [ {{
    "name" : "mcen",
    "width" : 1,
    "type" : "constant",
    "value" : 0
  }}, {{
    "name" : "mc",
    "width" : 3,
    "type" : "constant",
    "value" : 0
  }}, {{
    "name" : "wa",
    "width" : 2,
    "type" : "constant",
    "value" : 0
  }}, {{
    "name" : "wpulse",
    "width" : 2,
    "type" : "constant",
    "value" : 0
  }}, {{
    "name" : "wpulseen",
    "width" : 1,
    "type" : "constant",
    "value" : 1
  }}, {{
    "name" : "fwen",
    "width" : 1,
    "type" : "constant",
    "value" : 0
  }}, {{
    "name" : "clkbyp",
    "width" : 1,
    "type" : "constant",
    "value" : 0
  }} ]
}}
  """.format(n=sram_name.strip(), d=m.group(1), w=m.group(2), m=m.group(3), mask_port=""",
    "mask port name" : "wbeb",
    "mask port polarity" : "active low",
    "mask granularity" : 1
    """ if m.group(4) == "1" else ""))
        else:
            print("Unsupported memory: {n}".format(n=sram_name))
    else:
        print("Unsupported memory: {n}".format(n=sram_name))

with open(sys.argv[2], "w") as f:
    f.write("[\n")
    for i in range(0, len(json)):
        f.write(json[i])
        if i != (len(json) - 1):
            f.write(",")
    f.write("]\n")

print(str(len(json)) + " SRAMs converted into json")
