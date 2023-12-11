#####################################
# Calibre fill targets for Intech22 #
#####################################
# Fill decks require Calibre 2021.1_45.34 +
# See $Fill_RUNSET/1222_calibre_fill_userguide.pdf for usage details
PDK_VERSION ?= pdk224_r0.9.2
FILL_CALIBRE_VERSION ?= 2022.2_24.16
FILL_CALIBRE_BIN ?= /tools/mentor/calibre/aoi_cal_$(FILL_CALIBRE_VERSION)/bin
# Required for calibredrv call in decks. Make sure you do not already have another calibre in your PATH.
export PATH := ${PATH}:$(FILL_CALIBRE_BIN)

#BSUB ?= bsub -q bora7
## If we are already in the LSF, don't use bsub to run
#ifdef LSF_INVOKE_CMD
#CMD =
#else
#CMD = $(BSUB) -K
#endifmake

# GDS in par-rundir
ifndef PRE_FILL_GDS
PAR_TARGET := $(subst drc,,$(HAMMER_DRC_TARGET))
PAR_OUTPUT := $(abspath $(OBJ_DIR))/$(if $(PAR_TARGET),par$(PAR_TARGET),par-rundir)/par-output.json
PRE_FILL_GDS := $(shell grep par.outputs.output_gds $(PAR_OUTPUT) | cut -d\" -f4)
endif

# Deuniquification script. Needed to pass illegal layer checks. WARNING: overwrites $(PRE_FILL_GDS).
LAYOUT_FIX_SCRIPT := $(vlsi_dir)/hammer-intech22-plugin/hammer/intech22/signoff/fix_layout.tcl
CELLS_TO_DEUNIQUIFY ?= fdk22tic2_dicregcdply_cont fdk22tic4m1_diccd_cont fdk22tic4m1_dicreg_cont fdk22b82lto_b88xesdclpn6000qnxcnx b88xesdtxte1padxxxulx b88xesdtxte1pwrxxxulx b88xesddjpu1ogdxnxunx b88xesddjnu1ogdxnxunx x22hdcsramtrbitcorner x22hdcsramtrbittodecx2 x22hdclpbit x22hdclpbitedge b88xesdclpe4000qlxcnx b88xesdclpn4000qnxcnx b88xesdclpn6000qnxcnx b84xprsu b84xdiccd b84xdicreg
POST_DEUNIQ_OAS := $(basename $(PRE_FILL_GDS)).oas
deuniquify: $(POST_DEUNIQ_OAS)
$(POST_DEUNIQ_OAS): $(PRE_FILL_GDS)
	$(CMD) calibredrv $(LAYOUT_FIX_SCRIPT) $(PRE_FILL_GDS) $(CELLS_TO_DEUNIQUIFY)

.PHONY: fill clean-fill submit-2x2 clean-2x2

# Run fill decks
POST_FILL_GDS = $(abspath $(OBJ_DIR))/fill-drc/$(HAMMER_DRC_RUNDIR)/$(basename $(notdir $(PRE_FILL_GDS)))_fill.gds
fill: $(POST_FILL_GDS)
fill: export DR_PROCESS = dotFour
fill: export Fill_RUNSET ?= /tools/intech22/PDK/$(PDK_VERSION)/fill/siemens/runsets
# Setting to resolve fill issues over SRAMs
fill: export RFTsettings = YES
fill: export FILL_INPUT_FILE := $(POST_DEUNIQ_OAS)
fill: export FILL_INPUT_FILE_TYPE = OASIS
fill: export FILL_OUTPUT_FILE_TYPE = GDS
fill: export LAYERSTACK = m11_1x_3xa_1xb_1xc_2yb_2ga_mim2_1gb__bumpp

#fill: export DR_MIM_FILL = true
$(POST_FILL_GDS): | deuniquify
	mkdir -p $(dir $@)
	$(CMD) cd $(dir $@) && calibre -drc -hier -turbo -hyper $(Fill_RUNSET)/p1222_fill.svrf

# setup for the 2x2 (use uni 2x2 by default)
PACKAGE_2x2 := UNI
BASE_FILL_GDS := $(abspath $(OBJ_DIR))/fill-drc/$(HAMMER_DRC_RUNDIR)/$(basename $(notdir $(PRE_FILL_GDS)))_base_fill.gds
METAL_FILL_GDS := $(abspath $(OBJ_DIR))/fill-drc/$(HAMMER_DRC_RUNDIR)/$(basename $(notdir $(PRE_FILL_GDS)))_metal_fill.gds
LAYOUT_2X2_FIX_SCRIPT := $(vlsi_dir)/hammer-intech22-plugin/hammer/intech22/signoff/fix_layout_2x2.tcl
SUBMISSION_FOLDER := $(abspath $(OBJ_DIR))/2x2_submission

# add new 2x2 finishing options here.
ifeq ($(PACKAGE_2x2), UNI)
	BUMP_NAME = c4bx54mgb
	SUBMISSION_2x2_NAME = 8su722v_dot4opt1_0a_UCB1222
	PACKAGE_2x2_NAME = uni2_2x2sub4x4_c4_er_edm_prs_top_cnr
	QUADRANT_NAME = quadrant_pins_uni2
	STANDALONE_OAS_2x2 = $(SUBMISSION_FOLDER)/$(SUBMISSION_2x2_NAME).oas
	PLACED_OAS_2x2 = $(SUBMISSION_FOLDER)/$(PACKAGE_2x2_NAME).oas
# Need Brian to put the packages in a location.
	DR_PATH = /tools/C/ee290-sp23/packaging_collateral/$(PACKAGE_2x2_NAME).gds
endif	

submit-2x2: $(STANDALONE_OAS_2x2) $(PLACED_OAS_2x2)
$(STANDALONE_OAS_2x2) $(PLACED_OAS_2x2): $(POST_FILL_GDS)
	mkdir -p  $(SUBMISSION_FOLDER)
	$(CMD) calibredrv $(LAYOUT_2X2_FIX_SCRIPT) $(STANDALONE_OAS_2x2) $(PLACED_OAS_2x2) $(PRE_FILL_GDS) $(BASE_FILL_GDS) \
	$(METAL_FILL_GDS) $(DR_PATH) $(PACKAGE_2x2_NAME) $(QUADRANT_NAME) $(BUMP_NAME)
	$(CMD) calibredrv $(LAYOUT_FIX_SCRIPT) $(STANDALONE_OAS_2x2) OAS_ONLY $(CELLS_TO_DEUNIQUIFY)
	$(CMD) calibredrv $(LAYOUT_FIX_SCRIPT) $(PLACED_OAS_2x2) OAS_ONLY $(CELLS_TO_DEUNIQUIFY)

clean-fill:
	cd $(abspath $(OBJ_DIR)) && rm -rf $(METAL_FILL_CONF) $(BASE_FILL_CONF) $(UV_FILL_CONF) metal-fill-drc base-fill-drc uv-fill-drc && cd $(vlsi_dir)

clean-2x2:
	rm -rf $(SUBMISSION_FOLDER)
