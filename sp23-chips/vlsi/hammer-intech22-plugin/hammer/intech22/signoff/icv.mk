####################################
# ICV DRC/LVS targets for Intech22 #
####################################
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

# Refer to $PDK_VERSION/doc/Intel_P1222_29_PDK_User_Guide_<PDK_VERSION>.pdf for 
# more information about physical verification with ICV. Summary:
# Block & chip-level required flows:
# - drcd
# - drc_IPall
# - OpenRail
# - drc_IL
# - drc_LU
# - drc_TUC
# - denall
# - LVS
# Chip-level additional required flows:
# - tapein
# - drc_fullchip
# Optional flows are not included in this Makefile.

# To only run some DRC checks, pass in the list of DRCs into make
# e.g. make <deck_name>-drc RUN_ONLY_DRCS="rule1 rule2 rule3"

# If you are using SRAMs with no GDS provided, set a SRAM_NO_GDS variable.
# This prevents Calibre (fill) from erroring if a reference is not defined in the GDS.
ifdef SRAM_NO_GDS
MISSING_REFERENCE = LAYOUT INPUT EXCEPTION SEVERITY MISSING_REFERENCE 1
else
MISSING_REFERENCE =
endif

HAMMER_DRC_INPUT ?= $(abspath $(OBJ_DIR))/$(HAMMER_DRC_TARGET)-input.json
HAMMER_LVS_INPUT ?= $(abspath $(OBJ_DIR))/$(HAMMER_LVS_TARGET)-input.json

HAMMER_DRC_RUNDIR ?= $(if $(filter-out drc,$(HAMMER_DRC_TARGET)),$(HAMMER_DRC_TARGET),$(HAMMER_DRC_TARGET)-rundir)
HAMMER_LVS_RUNDIR ?= $(if $(filter-out lvs,$(HAMMER_LVS_TARGET)),$(HAMMER_LVS_TARGET),$(HAMMER_LVS_TARGET)-rundir)

ICV_RUNSET ?= /tools/intech22/PDK/$(PDK_VERSION)/runsets/icvtdr/PXL/StandAlone
# This ordering is optimal for DRC runtime for 'make -j2' or 'make -j4'
DECKS = fullchip denall il drcd tuc lu ipall tapein
drcd_DECK = $(ICV_RUNSET)/drcd.rs
ipall_DECK = $(ICV_RUNSET)/drc_IPall.rs
il_DECK = $(ICV_RUNSET)/drc_IL.rs
lu_DECK = $(ICV_RUNSET)/drc_LU.rs
tuc_DECK = $(ICV_RUNSET)/drc_TUC.rs
denall_DECK = $(ICV_RUNSET)/denall.rs
tapein_DECK = $(ICV_RUNSET)/tapein.rs
fullchip_DECK = $(ICV_RUNSET)/drc_fullchip.rs

# Fill targets
include $(vlsi_dir)/hammer-intech22-plugin/hammer/intech22/signoff/fill.mk

# Post-tapein merge GDS
# The OAS is for final tapeout!!!
TAPEIN_GDS := $(abspath $(OBJ_DIR))/drc-tapein/$(HAMMER_DRC_RUNDIR)/$(TOP).gds
TAPEIN_OAS := $(basename $(TAPEIN_GDS)).oas
$(info TAPEIN_GDS=$(TAPEIN_GDS))

# Per deck Hammer confs
# Add 2x2 waiver if available for deck
CONFS = $(addprefix $(abspath $(OBJ_DIR))/,$(addsuffix .yml,$(DECKS)))
$(CONFS): %.yml:
	mkdir -p $(dir $@)
	echo "drc.inputs:" > $@
	echo "  additional_drc_text_mode: append" >> $@
	echo '  additional_drc_text: "#include <$($(notdir $*)_DECK)>"' >> $@
	if [[ -n $$FRAME_2x2 && -n $$WAIVER_AVAIL ]]; then \
	sed 's|waiver.oas|$(vlsi_dir)/hammer-intech22-plugin/hammer/intech22/drc/icv/$(WAIVER_DB)|g' $(vlsi_dir)/hammer-intech22-plugin/hammer/intech22/drc/icv/config.rs >  $(abspath $(OBJ_DIR))/config.rs ;\
	echo 'drc.icv.config_runset: "$(abspath $(OBJ_DIR))/config.rs"' >> $@ ;\
	fi

$(abspath $(OBJ_DIR))/tapein.yml:
	mkdir -p $(dir $@)
	echo "drc.inputs:" > $@
	echo "  additional_drc_text_mode: append" >> $@
	echo '  additional_drc_text: "#include <$(tapein_DECK)>"' >> $@
	echo "drc.icv.defines_meta: append" >> $@ ;\
	echo "drc.icv.defines:" >> $@ ;\
	echo "  - _drFULL_DIE: _drYES" >> $@ ;\
	echo "  - _drgdsAlso: _drYES" >> $@ ;\
	echo 'drc.inputs.layout_file: "$(POST_FILL_GDS)"' >> $@

# We want this to be deleted each time
#if [[ -n $$RUN_ONLY_DRCS ]]; then \
#echo "drc.inputs.drc_rules_to_run:" > $@ ;\ 
#fi
DRC_CONF = $(abspath $(OBJ_DIR))/$(HAMMER_DRC_TARGET).yml
.INTERMEDIATE: $(DRC_CONF)
$(DRC_CONF):
	mkdir -p $(dir $@)
	echo "" > $@ 
	for x in $(RUN_ONLY_DRCS); do \
	echo "  - "'"'$$x'"' >> $@ ; \
	done
	if [[ -n $$FULL_CHIP ]]; then \
	echo "drc.icv.defines_meta: append" >> $@ ;\
	echo "drc.icv.defines:" >> $@ ;\
	echo "  - _drFULL_DIE: _drYES" >> $@ ;\
	echo "  - _drSINGLEDIE_PRS: _drYES" >> $@ ;\
	fi
	if [[ -n $$FILLED_CHIP ]]; then \
	echo 'drc.inputs.layout_file: "$(TAPEIN_GDS)"' >> $@ ;\
	fi

DRC_TARGETS = $(addprefix drc-,$(DECKS))
DRC_FINAL_TARGETS = $(addprefix drc-final-,$(filter-out tapein,$(DECKS)))
.PHONY: drc-block drc-chip drc-final $(DRC_TARGETS) $(DRC_FINAL_TARGETS)

# This ordering is optimal for DRC runtime for 'make -j2' or 'make -j4'
drc-block: drc-denall drc-il drc-drcd drc-tuc drc-lu drc-ipall # note: denall not valid until post-fill

drc-chip: drc-fullchip drc-block
drc-final: $(DRC_FINAL_TARGETS)

# flag that turns on full die checks
drc-chip: export FULL_CHIP = YES
drc-final: export FULL_CHIP = YES 
$(DRC_FINAL_TARGETS): export FULL_CHIP = YES

# flag that switches to post-fill GDS
drc-final: export FILLED_CHIP = YES
$(DRC_FINAL_TARGETS): export FILLED_CHIP = YES

# Add waivers for 2x2 corner frame
drc-drcd: export WAIVER_AVAIL = YES
drc-drcd:  WAIVER_DB = uni2_2x2sub4x4_cnr_drcd_waivers.oas
drc-final-drcd: WAIVER_DB = uni2_2x2sub4x4_cnr_drcd_waivers.oas
drc-final-drcd: export WAIVER_AVAIL = YES
drc-final-il: export WAIVER_AVAIL = YES
drc-final-il: WAIVER_DB = uni2_2x2sub4x4_cnr_IL_waivers.oas
drc-il: export WAIVER_AVAIL = YES
drc-il: WAIVER_DB = uni2_2x2sub4x4_cnr_IL_waivers.oas

$(DRC_TARGETS) $(DRC_FINAL_TARGETS): %: $(abspath $(OBJ_DIR))/%/$(HAMMER_DRC_RUNDIR)/drc-output.json

$(abspath $(OBJ_DIR))/drc-%/$(HAMMER_DRC_RUNDIR)/drc-output.json: $(DRC_CONF) $(abspath $(OBJ_DIR))/%.yml | deuniquify
	$(HAMMER_EXEC) -e $(ENV_YML) -p $(HAMMER_DRC_INPUT) $(foreach x,$(HAMMER_DRC_CONFS) $^, -p $(x)) $(HAMMER_EXTRA_ARGS) --obj_dir $(abspath $(OBJ_DIR))/drc-$* $(HAMMER_DRC_TARGET)

$(abspath $(OBJ_DIR))/drc-final-%/$(HAMMER_DRC_RUNDIR)/drc-output.json: $(DRC_CONF) $(abspath $(OBJ_DIR))/%.yml | drc-tapein
	$(HAMMER_EXEC) -e $(ENV_YML) -p $(HAMMER_DRC_INPUT) $(foreach x,$(HAMMER_DRC_CONFS) $^, -p $(x)) $(HAMMER_EXTRA_ARGS) --obj_dir $(abspath $(OBJ_DIR))/drc-final-$* $(HAMMER_DRC_TARGET)

$(abspath $(OBJ_DIR))/drc-tapein/$(HAMMER_DRC_RUNDIR)/drc-output.json: $(DRC_CONF) $(abspath $(OBJ_DIR))/tapein.yml | fill
	$(HAMMER_EXEC) -e $(ENV_YML) -p $(HAMMER_DRC_INPUT) $(foreach x,$(HAMMER_DRC_CONFS) $^, -p $(x)) $(HAMMER_EXTRA_ARGS) --obj_dir $(abspath $(OBJ_DIR))/drc-tapein $(HAMMER_DRC_TARGET)
	$(FILL_CALIBRE_BIN)/calibredrv $(LAYOUT_FIX_SCRIPT) $(TAPEIN_GDS)

# We want this to be deleted each time
# LVS deck is already included in the tech plugin
LVS_CONF = $(abspath $(OBJ_DIR))/$(HAMMER_LVS_TARGET).yml
.INTERMEDIATE: $(LVS_CONF)
$(LVS_CONF):
	mkdir -p $(dir $@)
	touch $@
	# Report opens required in full chip LVS
	if [[ -n $$FULL_CHIP ]]; then \
	echo "lvs.icv.defines_meta: append" >> $@ ;\
	echo "lvs.icv.defines:" >> $@ ;\
	echo "  - _drTOPCHECK: _drcheck" >> $@ ;\
	fi
	if [[ -n $$FILLED_CHIP ]]; then \
	echo 'lvs.inputs.layout_file: "$(POST_FILL_GDS)"' >> $@ ;\
	fi

.PHONY: lvs-block lvs-chip lvs-final

lvs-block: $(abspath $(OBJ_DIR))/$(HAMMER_LVS_RUNDIR)/lvs-output.json
lvs-chip: export FULL_CHIP = YES  # flag that turns on virtual open connection reporting
lvs-chip: lvs-block
lvs-final: export FILLED_CHIP = YES  # flag that switches to post-fill GDS
lvs-final: export FULL_CHIP = YES
lvs-final: $(abspath $(OBJ_DIR))/lvs-final/$(HAMMER_LVS_RUNDIR)/lvs-output.json

# Note: dependence on dequniquify recipe may mean you need to set HAMMER_DRC_TARGET also for hier flow
$(abspath $(OBJ_DIR))/$(HAMMER_LVS_RUNDIR)/lvs-output.json: $(LVS_CONF) | deuniquify
	$(HAMMER_EXEC) -e $(ENV_YML) -p $(HAMMER_LVS_INPUT) $(foreach x,$(HAMMER_LVS_CONFS) $^, -p $(x)) $(HAMMER_EXTRA_ARGS) --obj_dir $(abspath $(OBJ_DIR)) $(HAMMER_LVS_TARGET)

$(abspath $(OBJ_DIR))/lvs-final/$(HAMMER_LVS_RUNDIR)/lvs-output.json: $(LVS_CONF) | fill
	$(HAMMER_EXEC) -e $(ENV_YML) -p $(HAMMER_LVS_INPUT) $(foreach x,$(HAMMER_LVS_CONFS) $^, -p $(x)) $(HAMMER_EXTRA_ARGS) --obj_dir $(abspath $(OBJ_DIR))/lvs-final $(HAMMER_LVS_TARGET)

.PHONY: signoff

signoff: lvs-final drc-final

.PHONY: clean-drc clean-lvs

clean-drc:
	cd $(abspath $(OBJ_DIR)) && rm -rf $(CONFS) $(DRC_TARGETS) $(DRC_FINAL_TARGETS) && cd $(vlsi_dir)

clean-lvs:
	cd $(abspath $(OBJ_DIR)) && rm -rf $(HAMMER_LVS_RUNDIR) lvs-final && cd $(vlsi_dir)
