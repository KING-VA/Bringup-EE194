# Getting New SRAMs

At BWRC, SRAMs in Intel 16 must be ordered from the foundry. Here are the steps:

## 1. Figuring out which memories you need

To decide which memories you need (assuming you are using Chipyard):

1. In `CHIPYARD/vlsi/`, run `make syn CONFIG=YOURCONFIG USE_SRAM_COMPILER=1`
    * This will run MacroCompiler with the options `-l $(SMEMS_COMP) --use-compiler`, which will make it generate .
    * Due to a MacroCompiler bug, you will need to manually edit your `<design>.top.mems.conf` in `generated-src/.../` so that single-port (rw or mrw) SRAMs have a min. depth of 512. I.e., you will run `make syn` as indicated above (it will crash in MacroCompiler), fix the `<design>.top.mems.conf` file, then re-run `make syn` as indicated above.
        * Note: Once you have the ordered SRAMs and follow the installation steps below (i.e. SRAMs are in `sram-cache.json` in the hammer-intech22-plugin), you will no longer need to manually increase the min. depth to 512.
2. Find out what memories it compiled to in your `<design>.mems.hammer.json` file. You will use this information to place an order.

## 2. Placing an order

First, grab the memory order form XLSX template from sharepoint (`sharepoint/USP/memory_compiler/memory\ compiler\ 26october2022.xlsx`). This has the following format:

* Sheet 1: Readme
* Sheet 2: 1 Port SRAM
* Sheet 3: 2 Port RF
* Sheet 4: Result

For each single-port SRAM identified in `<design>.mems.hammer.json` (that isn't already in `bwrc_srams.txt`), fill in Sheet 2 like so:
* `Name of memory`: leave blank, it's optional
* `Output View`: Recommended to be set to `Full`
* `Column Mux`: Set to the value of `mux` from the json
* `Word Depth`: Depth (num entries)
* `Word Width`: Width (num bits per entry)
* `Timing Derate Enable`: `0`
* `Power Management Enable`: `0`
* `Column Redundancy`: `0`
* `Bit write enable`: `1` if json says `true` for `mask` else put `0`
* `Comma separated PVT corners`: Copy-paste the entire list from `Choose from following corners:` in the top right of the sheet

For each dual-port RF identified in `<design>.mems.hammer.json` (that isn't already in `bwrc_srams.txt`), fill in Sheet 3 like so:
* `Name of memory`: leave blank, it's optional
* `Output View`: Recommended to be set to `Full`
* `Column Mux`: Set to the value of `mux` from the json
* `Word Depth`: Depth (num entries)
* `Word Width`: Width (num bits per entry)
* `Timing Derate Enable`: `0`
* `Power Management Enable`: Leave as `p-1=NoPME` until we support SRAM sleep
* `Bit write enable`: `1` if json says `true` for `mask` else put `0`
* `Comma separated PVT corners`: Copy-paste the entire list from `Choose from following corners:` in the top right of the sheet

Based on the above inputs, Sheet 4 will be automatically populated.

Submit this XLSX on the portal and wait for a response.

## 3. Installing the delivered SRAMs

Once you receive the archive of SRAMs, do the following:

1. Extract the archive to `/tools/intech22/local/IP/`. You will likely need an admin to do this.
2. Go to `/tools/intech22/local/memory/` and run the following for each SRAM you were delivered: `python3 postprocess_memory.py <sram_name>`
3. Go to `CHIPYARD/vlsi/hammer-intech22-plugin/hammer/intech22/`
4. Add the names of each SRAM to the list in `bwrc_srams.txt`
5. Run the cache gen script: `./sram-cache-gen.py bwrc_srams.txt sram-cache.json`
6. Commit the updated `intech22` folder
7. Finally, you can re-elaborate your design with Chipyard's default MacroCompiler options (`-l $(SMEMS_CACHE) -hir $(SMEMS_HAMMER)`) by removing `USE_SRAM_COMPILER=1` from the command. e.g., `make syn CONFIG=YOURCONFIG`


Remember to include the following tcl snippets in your P&R flow, assuming `VDD` & `VSS` supplies:
`connect_global_net VDD -type pg_pin -pin_base_name vddp -verbose`
`connect_global_net VSS -type pg_pin -pin_base_name vss -verbose`
