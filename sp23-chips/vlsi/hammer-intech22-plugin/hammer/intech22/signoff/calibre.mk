########################################
# Calibre DRC/LVS targets for Intech22 #
########################################
# You must include this in your vlsi Makefile.
# This assumes you will be using a Makefile that defines the following variables:
# HAMMER_EXEC - The hammer executable
# OBJ_DIR - The obj_dir argument passed to hammer
# ENV_YML - The environment yaml passed to hammer
# HAMMER_DRC/LVS_CONFS - The list of confs to pass to DRC/LVS
# HAMMER_DRC/LVS_TARGET - The hammer DRC/LVS target.
#   For hierarchical designs, make this drc-$(TOPMODULE) and lvs-$(TOPMODULE)
#   For flat designs, make this drc and lvs
HAMMER_DRC_CONFS ?= $(INPUT_CONFS)
HAMMER_LVS_CONFS ?= $(INPUT_CONFS)
HAMMER_DRC_TARGET ?= drc
HAMMER_LVS_TARGET ?= lvs

# Refer to /tools/intech22/PDK/<PDK_version>/doc/Intel_P1222_2_PDK_User_Guide_r<version>.pdf for 
# more information about physical verification with Calibre. Summary:
# Block & chip-level required flows:
# - DRCC
# - DRCPERC
# - Denall
# - IPall
# - OpenRail
# - LVS
# Chip-level additional required flows:
# - tapein_merge
# - PRS Utility
# - SingleBump
# Optional flows are not included in this Makefile.

# To only run some DRC checks, pass in the list of DRCs into make
# e.g. make <deck_name>-drc RUN_ONLY_DRCS="rule1 rule2 rule3"
# Does not work for DRCPERC or TAPEIN_MERGE because they do not utilize Hammer

# If you are using SRAMs with no GDS provided, set a SRAM_NO_GDS variable.
# This prevents Calibre from erroring if a reference is not defined in the GDS.
ifdef SRAM_NO_GDS
MISSING_REFERENCE = LAYOUT INPUT EXCEPTION SEVERITY MISSING_REFERENCE 1
else
MISSING_REFERENCE =
endif

HAMMER_DRC_INPUT ?= $(abspath $(OBJ_DIR))/$(HAMMER_DRC_TARGET)-input.json
HAMMER_LVS_INPUT ?= $(abspath $(OBJ_DIR))/$(HAMMER_LVS_TARGET)-input.json

HAMMER_DRC_RUNDIR ?= $(if $(filter-out drc,$(HAMMER_DRC_TARGET)),$(HAMMER_DRC_TARGET),$(HAMMER_DRC_TARGET)-rundir)
HAMMER_LVS_RUNDIR ?= $(if $(filter-out lvs,$(HAMMER_LVS_TARGET)),$(HAMMER_LVS_TARGET),$(HAMMER_LVS_TARGET)-rundir)

export Calibre_RUNSET ?= /tools/intech22/PDK/$(PDK_VERSION)/runsets/calibre/svrf
export DR_PROCESS = dotFour
export DR_INPUT_FILE_TYPE = GDS
Calibre_ENV = $(Calibre_RUNSET)/p1222.env
DECKS = drcc drcperc denall ipall tapein-merge prs single-bump
drcc_DECK = $(Calibre_RUNSET)/p1222_drcc.svrf
drcperc_DECK = $(Calibre_RUNSET)/p1222_drcperc.svrf
denall_DECK = $(Calibre_RUNSET)/p1222_denall.svrf
ipall_DECK = $(Calibre_RUNSET)/p1222_IPall.svrf
tapein-merge_DECK = $(Calibre_RUNSET)/p1222_tapein_merge.sh
prs_DECK = $(Calibre_RUNSET)/p1222_prs.svrf
single-bump_DECK = $(Calibre_RUNSET)/p1222_SingleBump.svrf

# DRC decks require Calibre 2021.1_45.34 +
DRC_CALIBRE_VERSION ?= 2021.2_28.15
DRC_CALIBRE_BIN ?= /tools/mentor/calibre/aoi_cal_$(DRC_CALIBRE_VERSION)/bin
MGLS_LICENSE_FILE ?= 1717@bwrcflex-1.eecs.berkeley.edu

# Fill targets
include $(vlsi_dir)/hammer-intech22-plugin/hammer/intech22/signoff/fill.mk

# Post-tapein merge GDS
# The OAS is for final tapeout!!!
TAPEIN_GDS := $(abspath $(OBJ_DIR))/drc-tapein-merge/$(notdir $(POST_FILL_GDS))
TAPEIN_OAS := $(basename $(TAPEIN_GDS)).oas

# Per deck Hammer confs
CONFS = $(addprefix $(abspath $(OBJ_DIR))/,$(addsuffix .yml,$(DECKS)))
$(CONFS): %.yml:
	mkdir -p $(dir $@)
	echo "drc.inputs:" > $@
	echo "  additional_drc_text_mode: append" >> $@
	echo '  additional_drc_text: "$(MISSING_REFERENCE)\nINCLUDE $($(notdir $*)_DECK)"' >> $@

# We want this to be deleted each time
DRC_CONF = $(abspath $(OBJ_DIR))/$(HAMMER_DRC_TARGET).yml
.INTERMEDIATE: $(DRC_CONF)
$(DRC_CONF):
	mkdir -p $(dir $@)
	echo "drc.inputs.drc_rules_to_run:" > $@
	for x in $(RUN_ONLY_DRCS); do \
	echo "  - "'"'$$x'"' >> $@ ; \
	done
	if [[ -n $$FILLED_CHIP ]]; then \
	echo 'drc.inputs.layout_file: "$(TAPEIN_GDS)"' >> $@ ;\
	fi

DRC_TARGETS = $(addprefix drc-,$(DECKS)))
DRC_FINAL_TARGETS = $(addprefix drc-final-,$(filter-out tapein-merge,$(DECKS)))
.PHONY: drc-block drc-chip drc-final $(DRC_TARGETS) $(DRC_FINAL_TARGETS)

drc-block: drc-drcc drc-drcperc drc-ipall drc-denall # note: denall not valid until post-fill
drc-chip: drc-block drc-prs drc-single-bump
drc-final: $(DRC_FINAL_TARGETS)

# flag that turns off checks pre-fill
drc-block: export DR_PREFILL = YES
drc-chip: export DR_PREFILL = YES

# flag that turns on full die checks
drc-chip: export DR_FULL_DIE = YES
drc-final: export DR_FULL_DIE = YES
$(DRC_FINAL_TARGETS): export DR_FULL_DIE = YES

# flag that switches to post-fill GDS
drc-final: export FILLED_CHIP = YES
$(DRC_FINAL_TARGETS): export FILLED_CHIP = YES

HAMMER_DRC_TARGETS = $(patsubst %perc,,$(patsubst %merge,,$(DRC_TARGETS) $(DRC_FINAL_TARGETS)))
$(HAMMER_DRC_TARGETS): %: $(abspath $(OBJ_DIR))/%/$(HAMMER_DRC_RUNDIR)/drc-output.json
drc-drcperc: $(abspath $(OBJ_DIR))/drc-drcperc/$(HAMMER_DRC_RUNDIR)/drc_results.rpt
drc-final-drcperc: $(abspath $(OBJ_DIR))/drc-final-drcperc/$(HAMMER_DRC_RUNDIR)/drc_results.rpt
drc-tapein-merge: $(TAPEIN_GDS)

$(abspath $(OBJ_DIR))/drc-%/$(HAMMER_DRC_RUNDIR)/drc-output.json: $(HAMMER_DRC_INPUT) $(DRC_CONF) $(abspath $(OBJ_DIR))/%.yml
	$(HAMMER_EXEC) -e $(ENV_YML) $(foreach x,$(HAMMER_DRC_CONFS) $^, -p $(x)) --obj_dir $(abspath $(OBJ_DIR))/drc-$* $(HAMMER_DRC_TARGET)

$(abspath $(OBJ_DIR))/drc-final-%/$(HAMMER_DRC_RUNDIR)/drc-output.json: $(HAMMER_DRC_INPUT) $(DRC_CONF) $(abspath $(OBJ_DIR))/%.yml | drc-tapein-merge
	$(HAMMER_EXEC) -e $(ENV_YML) $(foreach x,$(HAMMER_DRC_CONFS) $^, -p $(x)) --obj_dir $(abspath $(OBJ_DIR))/drc-final-$* $(HAMMER_DRC_TARGET)

define DRCPERC_CMDS
source $(Calibre_ENV) &&\
setenv PATH $(DRC_CALIBRE_BIN):$(PATH) &&\
setenv DR_RVE_FILE drc_results.db &&\
setenv DR_REPORT_FILE drc_results.rpt &&\
bsub -Is -q bora '$(DRC_CALIBRE_BIN)/calibre -64 -perc -ldl -hier $(drcperc_DECK)'
endef
$(abspath $(OBJ_DIR))/%-drcperc/$(HAMMER_DRC_RUNDIR)/drc_results.rpt: export DR_INPUT_FILE := $(if $(FILLED_CHIP)==YES,$(TAPEIN_GDS),$(PRE_FILL_GDS))
$(abspath $(OBJ_DIR))/drc-drcperc/$(HAMMER_DRC_RUNDIR)/drc_results.rpt: $(HAMMER_DRC_INPUT)
	mkdir -p $(abspath $(OBJ_DIR))/drc-drcperc/$(HAMMER_DRC_RUNDIR) && cd $$_ && \
	csh -c "$(eval $(DRC_PERC_CMDS))" && cd $(vlsi_dir)
$(abspath $(OBJ_DIR))/drc-final-drcperc/$(HAMMER_DRC_RUNDIR)/drc_results.rpt: $(HAMMER_DRC_INPUT) | drc-tapein-merge
	mkdir -p $(abspath $(OBJ_DIR))/drc-final-drcperc/$(HAMMER_DRC_RUNDIR) && cd $$_ && \
	csh -c "$(eval $(DRC_PERC_CMDS))" && cd $(vlsi_dir)

$(TAPEIN_GDS): export DR_INPUT_FILE := $(if $(FILLED_CHIP)==YES,$(POST_FILL_GDS),$(PRE_FILL_GDS))
$(TAPEIN_GDS): export DR_INPUT_CELL = $(basename $(notdir $(DR_INPUT_FILE)))
$(TAPEIN_GDS): export tapeInMergeFlowOutput = $(dir $(TAPEIN_GDS))
$(TAPEIN_GDS): export DR_OUTPUT_FILE = $(tapeInMergeFlowOutput)/$(DR_INPUT_CELL).oas
$(TAPEIN_GDS): $(HAMMER_DRC_INPUT) | fill
	mkdir -p $(tapeInMergeFlowOutput)
	# Hack script to call run.tcl with tapeInMergeFlowOutput
	cp $(TAPEIN_MERGE_DECK) $(tapeInMergeFlowOutput)/p1222_tapein_merge.sh && \
	sed -i '/run.tcl/s/$$/ $$tapeInMergeFlowOutput/' $(tapeInMergeFlowOutput)/p1222_tapein_merge.sh && \
	csh -c "source $(Calibre_ENV) &&\
			setenv PATH $(DRC_CALIBRE_BIN):$(PATH) &&\
			bsub -Is -q bora $$tapeInMergeFlowOutput/p1222_tapein_merge.sh &&\
			bsub -Is -q bora '$(DRC_CALIBRE_BIN)/calibredrv -64 $(MERGE_SCRIPT) merge $$DR_INPUT_FILE $(TAPEIN_GDS) gds $(DR_OUTPUT_FILE)' &&\
			bsub -Is -q bora '$(DRC_CALIBRE_BIN)/calibredrv -64 $(MERGE_SCRIPT) merge $$DR_INPUT_FILE $(TAPEIN_OAS) oas $(DR_OUTPUT_FILE)'"

# We want this to be deleted each time
# LVS deck is already included in the tech plugin
LVS_CONF = $(abspath $(OBJ_DIR))/$(HAMMER_LVS_TARGET).yml
.INTERMEDIATE: $(LVS_CONF)
$(LVS_CONF):
	mkdir -p $(dir $@)
	touch $@ ;\
	if [[ -n $$FILLED_CHIP ]]; then \
	echo 'lvs.inputs.layout_file: "$(TAPEIN_GDS)"' >> $@ ;\
	fi

.PHONY: lvs-block lvs-chip lvs-final

lvs-block: $(abspath $(OBJ_DIR))/$(HAMMER_LVS_RUNDIR)/lvs-output.json
lvs-chip: export DR_FULL_DIE = YES  # flag that turns on virtual open connection reporting
lvs-chip: lvs-block
lvs-final: export FILLED_CHIP = YES  # flag that switches to post-fill GDS
lvs-final: export DR_FULL_DIE = YES
lvs-final: $(abspath $(OBJ_DIR))/lvs-final/$(HAMMER_LVS_RUNDIR)/lvs-output.json

$(abspath $(OBJ_DIR))/$(HAMMER_LVS_RUNDIR)/lvs-output.json: $(HAMMER_LVS_INPUT) $(LVS_CONF)
	$(HAMMER_EXEC) -e $(ENV_YML) $(foreach x,$(HAMMER_LVS_CONFS) $^, -p $(x)) --obj_dir $(abspath $(OBJ_DIR)) $(HAMMER_LVS_TARGET)

$(abspath $(OBJ_DIR))/lvs-final/$(HAMMER_LVS_RUNDIR)/lvs-output.json: $(HAMMER_LVS_INPUT) $(LVS_CONF) | fill
	$(HAMMER_EXEC) -e $(ENV_YML) $(foreach x,$(HAMMER_LVS_CONFS) $^, -p $(x)) --obj_dir $(abspath $(OBJ_DIR))/lvs-final $(HAMMER_LVS_TARGET)

.PHONY: signoff

signoff: lvs-final drc-final

.PHONY: clean-drc clean-lvs

clean-drc:
	cd $(abspath $(OBJ_DIR)) && rm -rf $(CONFS) $(DRC_TARGETS) $(DRC_FINAL_TARGETS) && cd $(vlsi_dir)

clean-lvs:
	cd $(abspath $(OBJ_DIR)) && rm -rf $(HAMMER_LVS_RUNDIR) lvs-final && cd $(vlsi_dir)
