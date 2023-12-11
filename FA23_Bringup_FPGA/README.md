# fpga-bringup-23

This repository contains FPGA bringup infrastructure for the FA23 bringup class chips.

## Repository Layout

```
bringup/         # the bringup FPGA
  Agilex_SOM.v   # top-level verilog file (z1top.v from EECS151 Lab)
robochip/        # FPGA version of taped-out RoboChip RTL
bearlyml/        # FPGA version of taped-out BearlyML RTL
```

## Caveats

We only have an FMC cable, not an FMC+ cable, so the robochip/ and bearlyml/ projects are setup to send signals over that. The FMC pins are mapped to the correct FMC+ pins on the bringup/ side.


## A quick note about more files -- to speed up development at the end of the semester and to get around a lack of BWRC remote access, some files are left in the tools/C directory of Ansa and Ethan Gao who generously allowed me to use their accounts.