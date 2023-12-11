import os, sys
import re
from sty import fg, ef, rs
from BumpInfo import bearly_table, robo_table

vlsi_dir = os.environ["gen_ir_dir"]
chip = sys.argv[1]
intel_def_file = "/tools/C/ee290-sp23/packaging_collateral/hl_core_top_gmb.def"
output_def_file = f"{vlsi_dir}/hammer-bump-plugin/def/{chip}.def"

# Read in intel def file
if chip == "bearly":
  df = bearly_table
else:
  df = robo_table

f = open(intel_def_file, "r")
lines = f.readlines()
f.close()
regex = "\( (\*|[0-9]+) (\*|[0-9]+) \)"
# Constants for translation (required because of different integration technique from Intel)
def_units = 2000    # defined in Intel DEF
x_off = 17.2800     # Measured in Innovus after full build compared against Hammer API bumps
y_off = 18.9000     # Measured in Innovus after full build compared against Hammer API bumps
x_off_def = int(x_off*def_units)
y_off_def = int(y_off*def_units)

# write out def with tapeout class ChipTop port name
f = open(output_def_file, "w+")
for l in lines:
  words = l.strip().split(" ")

  int_coords = []
  str_coords = list(sum(re.findall(regex, l),()))
  if (len(str_coords) != 0):
    for i in range(4):
      if(str_coords[i] == "*"):
        int_coords.append(str_coords[i])
      else:
        if (i%2):   # odd
          int_coords.append(int(str_coords[i]) + y_off_def)
        else:
          int_coords.append(int(str_coords[i]) + x_off_def)
    new_coord_str = "( {} {} ) ( {} {} )".format(*int_coords)
    new_line = re.sub("\( .* \)", new_coord_str, l)
  else:
    new_line = l

  if (words[0] == "-"): # if line defines signal
    try:
      our_map = df.get(words[1])["name"]
      f.write("- {}\n".format(our_map))
      if words[1] != our_map:
        print("[DEF-LOG]: {:<25} ---> {:>25}".format(words[1], our_map))
    except Exception as e:
      if words[1] == "vdd":
        f.write("- VDD\n")
        print("[DEF-LOG]: {:<25} ---> {:>25}".format(words[1], "VDD"))
      elif words[1] == "vss":
        f.write("- VSS\n")
        print("[DEF-LOG]: {:<25} ---> {:>25}".format(words[1], "VSS"))
      elif words[1] == "vddv":
        f.write("- VDDV\n")
        print("[DEF-LOG]: {:<25} ---> {:>25}".format(words[1], "VDDV"))
      elif words[1] == "vddh":
        f.write("- VDDV\n")
        print("[DEF-LOG]: {:<25} ---> {:>25}".format(words[1], "VDDV"))
      else:
        f.write(new_line)
  else:
    f.write(new_line) # write line which doesn't define signal

print("-"* 76)
print(ef.bold + fg(34) + "GENERATED:" +rs.fg + rs.ef + " A custom DEF for " + chip + " based on preferences.")
print("-"* 76)
f.close()

