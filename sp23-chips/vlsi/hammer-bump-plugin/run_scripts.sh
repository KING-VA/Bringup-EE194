#! /bin/bash

if [[ "$1" == "Bearly" ]] 
  then
  echo "Generating bump map for BearlyML"
  python3 hammer-bump-plugin/scripts/src/BearlyUtilDriver.py 
  python3 hammer-bump-plugin/scripts/src/GenerateGmbDefUcb.py bearly
else
  echo "Generating bump map for RoboChip"
  python3 hammer-bump-plugin/scripts/src/RoboChipUtilDriver.py 
  python3 hammer-bump-plugin/scripts/src/GenerateGmbDefUcb.py robo
fi
