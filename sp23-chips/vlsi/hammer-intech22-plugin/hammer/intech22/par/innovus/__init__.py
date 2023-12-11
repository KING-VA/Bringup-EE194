#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
#  intech22 Innovus hooks.
#

from hammer.vlsi import HammerPlaceAndRouteTool, HammerTool

from typing import List, Dict, Tuple, Any, Iterable, Callable, Optional
from hammer.tech.specialcells import CellType

################
# Pre-DB Hooks #
################
def intech22_pre_db(ht: HammerTool) -> bool:
    """
    Adapted from pre_db.tcl in Intel reference flow.
    Settings that need to be applied before any LEFs or DBs are loaded
    Required for Innovus & Tempus
    """
    ht.append('''
    ##QRC layer map for route extraction
    set_db extract_rc_lef_tech_file_map {PDK}/extraction/qrc/asic/m11_1x_3xa_1xb_1xc_2yb_2ga_mim2_1gb__bumpp/asic.qrc.map

    set_db read_physical_must_join_all_ports true
    set mustjoinallports_is_one_pin 1

    # Setting SOCV options as per Cadence recommendation
    set_db timing_library_gen_setup_constraint_table_using_sigma_values sigma
    set_db timing_library_gen_hold_constraint_table_using_sigma_values sigma
    set_db timing_library_setup_sigma_multiplier 1.5
    set_db timing_library_hold_sigma_multiplier 3
    '''.format(PDK=ht.get_setting("technology.intech22.pdk_install_dir")), clean=True)
    return True

##########################
# Optional Innovus hooks #
##########################

def intech22_fiducials(ht: HammerTool) -> bool:
    """
    Adapted from pre_place_fiducial.tcl in Intel reference flow.
    Used for placing local fiducials between floorplanning & cell placement.
    """
    assert isinstance(ht, HammerPlaceAndRouteTool)
    ht.append('''
        #Setting up the fiducial cell from the block setup file.
        set fidxcell b15qfd1x2an1nnpx5

        #Creating x and y step based on modular grid-defined in block_setup
        set grid_x 0.108
        set grid_y 0.63
        set default_xstep [expr $grid_x * 25]
        set default_ystep [expr $grid_y * 16]
        set default_strtx [expr $grid_x * -12.5]
        set default_strty [expr $grid_y * -8]

        # getting the width and height of the cell from the library; and saving it.
        set fid1width [get_db base_cell:$fidxcell .bbox.dx]
        set fid1height [get_db base_cell:$fidxcell .bbox.dy]

        ## Create gaps 2 times width and height - 0.001 to provide max area for just one cell
        set gap1x [expr $fid1width + $fid1width - 0.001]
        set gap1y [expr $fid1height + $fid1height - 0.001]

        # Getting the core bounding points.
        set die_llx [get_db current_design .core_bbox.ll.x]
        set die_lly [get_db current_design .core_bbox.ll.y]
        set die_urx [get_db current_design .core_bbox.ur.x]
        set die_ury [get_db current_design .core_bbox.ur.y]
        set cnt 0

        #######################################
        ### Start placement of fid cells
        ########################################

        set ystep_cnt 0
        set x1 [expr $die_llx + $default_strtx]
        set y1 [expr $die_lly + $default_strty]
        set x2 $x1
        while {$y1<$die_ury} {
          set y2 [expr $y1 + $default_ystep - $gap1y]
          if {$y1<$die_ury-0.001} {
            create_place_blockage -rects "$die_llx $y1 $die_urx $y2" -name lfid_${cnt}
          }
          incr cnt
          incr ystep_cnt
          set step $default_xstep
          if {[expr $ystep_cnt%2] == 0} {
            set offx 0
          } else {
            set offx [expr $default_xstep/2]
          }
        # Offset added here to ensure that the empty areas in the placement blockage are staggered.
          set y1 [expr $y1+$default_ystep];
          set x1 [expr $die_llx-$offx];
          if {$y1<$die_ury} {
           while {$x1<$die_urx} {
             set x2 [expr $x1 + $step - $gap1x];
             create_place_blockage -rects "$x1 $y2 $x2 $y1" -name lfid_${cnt}; incr cnt;
             set x1 [expr $x1 + $step];
           }
         }
        }
        # Adding the Fiducial Cell here.
        add_fillers -base_cells $fidxcell -area [get_db current_design .core_bbox] -prefix fcc -check_drc false -mark_fixed

        # Removing the placement blockage  added for fid placement now.
        delete_obj [get_db place_blockages -if {.name == lfid*}]

    ''', clean=True)
    return True

def intech22_io_fillers(ht: HammerTool) -> bool:
    assert isinstance(ht, HammerPlaceAndRouteTool)
    for ring in range(ht.get_setting("technology.intech22.io_rings")):
        ht.append('''
            add_io_fillers -io_ring {ring_num} -side top -cells spacer_2lego_n1 -filler_orient r0 -prefix iofill_
            add_io_fillers -io_ring {ring_num} -side bottom -cells spacer_2lego_n1 -filler_orient mx -prefix iofill_
            add_io_fillers -io_ring {ring_num} -side left -cells spacer_2lego_e1 -filler_orient r0 -prefix iofill_
            add_io_fillers -io_ring {ring_num} -side right -cells spacer_2lego_e1 -filler_orient my -prefix iofill_
        '''.format(ring_num=ring+1), clean=True)
    return True

def intech22_fc_route(ht: HammerTool) -> bool:
    assert isinstance(ht, HammerPlaceAndRouteTool)
    ht.append('''
        set_db flip_chip_bottom_layer gmb
        set_db flip_chip_top_layer gmb
        set_db flip_chip_route_width {width}
        # prevent manipulation of routed bumps
        set_db flip_chip_allow_routed_bump_edit false
        # connects power bumps to supply cell pin. no multi_pad_to_bump implemented (too much congestion)
        set_db flip_chip_connect_power_cell_to_bump true
        # DRC violations unless routes hit bump @ 90 degrees. Use with -double_bend_route to still have diagonal routes.
        set_db flip_chip_route_style manhattan
    '''.format(width=ht.get_setting("technology.intech22.fc_route_width")), clean=True)

    # Route signals first
    ht.append('''
        select_bumps -type signal
        route_flip_chip -target connect_bump_to_pad -selected_bumps -double_bend_route -keep_drc -verbose
        deselect_bumps
    ''', clean=True)

    # Route bumps next for bumps only within a certain distance from the specified edges
    for edge in ht.get_setting("technology.intech22.pg_bump_edges"):
        ht.append('select_bumps -max_distance_to_side {dist} -side {edge}'.format(dist=ht.get_setting("technology.intech22.pg_bump_max_dist"), edge=edge))
    ht.append('''
        deselect_bumps -type signal
        set_db flip_chip_bottom_layer gm0
        set_db flip_chip_top_layer gm0
        route_flip_chip -target connect_bump_to_pad -selected_bumps -incremental -double_bend_route -keep_drc -verbose
        deselect_bumps
    ''', clean=True)
    return True

#########################
# Default Innovus hooks #
#########################

def intech22_innovus_settings(ht: HammerTool) -> bool:
    assert isinstance(ht, HammerPlaceAndRouteTool), "Innovus settings only for par"
    assert ht.get_setting("par.innovus.version") >= "201", "Minimum Innovus version is 20.16-e041_1. See $PDK/doc/TOOLVERSIONS"
    '''
    Innovus tool constraints adapted from init_innovus_i22.tcl & create_pg_grid.tcl in Intel Reference Flow
    '''
    ht.append('''
    # Required for LVS
    set_db init_no_new_assigns true

    ## Power straps
    # To avoid via drops if overlap is not 100%
    set_db edit_wire_partial_overlap_threshold 100
    set_db generate_special_via_partial_overlap_threshold 1.0
    # Don't print so many warnings about METALWIDTHVIAMAP & overlap threshold
    set_db message:IMPPP-565 .max_print 20
    set_db message:IMPPP-5016 .max_print 20
    set_db generate_special_via_allow_wire_shape_change false
    set_db generate_special_via_opt_cross_via true
    set_db add_stripes_remove_floating_stripe_over_block false
    #Allow DRC Checks to flag and fix VIA drop issues at closed intersections over Macro
    set_db generate_special_via_ignore_drc false
    set_db add_stripes_ignore_drc false
    set_db add_stripes_skip_via_on_pin {}

    ## Place step Tool constraints
    ## ignore_followpin_vias for ignoring VIA1 drc during refine_place (on M1 Power Stripes in non-preferred direction)
    set_db design_ignore_followpin_vias true
    #to consider the effect of SI during timing
    set_db delaycal_enable_si true
    ##### Options to Enable LVF
    set_db timing_analysis_socv true ; set_db timing_analysis_type ocv ; set_db timing_analysis_cppr both

    ##route_options
    set_db route_early_global_bottom_routing_layer 2
    set_db route_early_global_top_routing_layer 8
    set_db route_design_bottom_routing_layer 2
    set_db route_design_top_routing_layer 8
    ###Required to prevent non-preferred direction routing
    set_db route_design_with_litho_driven true
    set_db route_design_detail_minimize_litho_effect_on_layer {t t t t t t t t}
    #Legacy command
    #eval_legacy "setNanoRouteMode -dRouteMinimizeLithoEffectOnLayer {t t t t t t t t}"
    set_db route_design_detail_on_grid_only {wire 1:1 via 1:1 pin_wire 1:1 pin_via 1:1}
    set_db route_design_detail_verbose_violation_summary 1
    set_db route_design_exp_advanced_pin_access 2
    set_db route_design_use_blockage_for_auto_ggrid true
    set_db route_design_strict_honor_route_rule true
    set_db route_design_detail_taper_dist_limit 0
    set_db route_design_detail_post_route_spread_wire false
    set_db route_design_use_auto_via false
    set_db route_design_detail_exp_advanced_violation_fix C2CCol
    set_db route_design_detail_exp_advanced_search_fix true
    set_db route_design_exp_use_var_width_route_rule false
    set_db route_design_exp_honor_route_rule_track true
    #to avoid m7 min port length violation
    set_pin_constraint -depth 0.54 -target_layers m7

    ###Antenna diodes
    set_db route_design_antenna_cell_name b15ydp151an1n03x5
    set_db route_design_antenna_diode_insertion true
    set_db route_design_diode_insertion_for_clock_nets true
    set_db route_design_with_via_in_pin "1:1"

    #to update the correct net names during stream out
    set_db write_stream_virtual_connection false

    #Demote SRAM bad SITEs to warnings
    set_message -id IMPSP-365 -severity warn
    ''', clean=True)
    return True

def intech22_create_sites(ht:HammerTool) -> bool:
    assert isinstance(ht, HammerPlaceAndRouteTool), "Innovus settings only for par"
    """
    Adapted from create_row.tcl in Intel Reference Flow.
    This is needed for double height tap cell placement and m2 power strap stapling.
    Adds place and power obstructions on top & bottom rows or else they will have no power.
    At the moment, this only works for rectangular floorplans (enforced by Hammer).
    """
    ht.append('''
    delete_row -all
    create_row -site {site} -flip_first_row
    create_row -site core2h -no_flip_rows -area [get_computed_shapes [get_db designs .core_bbox] SIZEY -0.63]
    create_row -site bonuscore -flip_first_row
    set tb_row_place_obs_rects [get_computed_shapes [get_db designs .core_bbox] andnot [get_computed_shapes [get_db designs .core_bbox] SIZEY -0.63]]
    create_place_blockage -rects "$tb_row_place_obs_rects" -name tb_row_place_obs
    '''.format(site=ht.technology.get_placement_site().name), clean=True)

    """
    Adapted from add_tracks.tcl in Intel Reference Flow.
    Default tracks are 1/2 pitch off-grid.
    """
    ht.append('''
    delete_tracks
    add_tracks -width_pitch_pattern {
            {m1 offset 0.0 width 0.068 pitch 0.108}
            {m2 offset 0.0 width 0.044 pitch 0.090}
            {m3 offset 0.0 width 0.044 pitch 0.090}
            {m4 offset 0.0 width 0.044 pitch 0.090}
            {m5 offset 0.0 width 0.044 pitch 0.090}
            {m6 offset 0.0 width 0.044 pitch 0.090}
            {m7 offset 0.0 width 0.180 pitch 0.360}
            {m8 offset 0.0 width 0.180 pitch 0.360}
    }
    ''', clean=True)
    return True

def intech22_tap_cells(ht: HammerTool) -> bool:
    assert isinstance(ht, HammerPlaceAndRouteTool), "Innovus settings only for par"
    """
    Replacement tap cell hook.
    Adapted from add_tap_cells.tcl in Intel Reference Flow.
    """
    interval = ht.get_setting("vlsi.technology.tap_cell_interval")
    offset = ht.get_setting("vlsi.technology.tap_cell_offset")
    tap_cells = ht.technology.get_special_cell_by_type(CellType.TapCell)[0].name

    ht.append('set INTEL_2H_TAP_CELL {}'.format(tap_cells[0]))
    ht.append('set INTEL_1H_TAP_CELL {}'.format(tap_cells[1]))
    # Set single height tapcell symmetry to xy (from just y - bad LEF)
    ht.append("set_db base_cell:$INTEL_1H_TAP_CELL .symmetry xy")
    # Avoid latchup conditions around pads using hard blockages
    ht.append('''
        set wd 0.432
        set ht 0.630
        set macros_list ""
        set macro_boxes ""
        set macros_list [get_db insts -if {.base_cell.base_class == block || .base_cell.base_class == pad}]
        if { $macros_list != ""} {
            set boxx ""
            foreach macro $macros_list {
                set m [get_computed_shapes [get_db $macro .overlap_rects]]
                set boxx [get_computed_shapes $m OR $boxx]
                set macro_boxes [get_computed_shapes [get_computed_shapes $boxx SIZEX $wd SIZEY $ht] OR [get_computed_shapes $boxx]]
            }
        }
        set tw [get_db base_cell:$INTEL_1H_TAP_CELL .bbox.width]
        set th [get_db base_cell:$INTEL_1H_TAP_CELL .bbox.length]
        set top_boxes [get_computed_shapes [get_db designs .boundary] ANDNOT [get_computed_shapes [get_db designs .boundary] SIZEX -$wd SIZEY -$ht]]
        set all_boxes [get_computed_shapes $macro_boxes OR $top_boxes]
        foreach box $all_boxes {
            set p0 [lindex $box 0]
            set p1 [lindex $box 1]
            set p2 [lindex $box 2]
            set p3 [lindex $box 3]
            set nbox0 [list [expr $p0-[expr 2*$tw]] [expr $p1-[expr 2*$th]] [expr $p0+[expr 2*$tw]] [expr $p1+[expr 2*$th]]]
            set nbox1 [list [expr $p2-[expr 2*$tw]] [expr $p1-[expr 2*$th]] [expr $p2+[expr 2*$tw]] [expr $p1+[expr 2*$th]]]
            set nbox2 [list [expr $p2-[expr 2*$tw]] [expr $p3-[expr 2*$th]] [expr $p2+[expr 2*$tw]] [expr $p3+[expr 2*$th]]]
            set nbox3 [list [expr $p0-[expr 2*$tw]] [expr $p3-[expr 2*$th]] [expr $p0+[expr 2*$tw]] [expr $p3+[expr 2*$th]]]
            create_place_blockage -area $nbox0 -name tap_cell_blockage_macro -type hard
            create_place_blockage -area $nbox1 -name tap_cell_blockage_macro -type hard
            create_place_blockage -area $nbox2 -name tap_cell_blockage_macro -type hard
            create_place_blockage -area $nbox3 -name tap_cell_blockage_macro -type hard
        }
    ''', clean=True)
    # double height cell
    ht.append("add_well_taps -cell $INTEL_2H_TAP_CELL -cell_interval {INTERVAL} -in_row_offset {OFFSET} -prefix TAP_2H".format(INTERVAL=interval, OFFSET=offset))
    # single height cell incremental
    ht.append("add_well_taps -cell $INTEL_1H_TAP_CELL -cell_interval {INTERVAL} -in_row_offset {OFFSET} -incremental {REF_CELL} -prefix TAP_1H".format(INTERVAL=interval, OFFSET=offset, REF_CELL=tap_cells[0]))
    # delete blockages
    ht.append("delete_obj [get_db place_blockages tap_cell_blockage_macro]")
    return True

def intech22_m2_staples(ht: HammerTool) -> bool:
    assert isinstance(ht, HammerPlaceAndRouteTool), "Innovus settings only for par"
    """
    Manually add bottom m1 stripe, m2 staples, then vias between m1, m2, & m3.
    Circumvents incomplete tech LEF VIAGENs that don't allow m1-m3 via stacks with m1 perp. to m3.
    Power & ground nets done separately to minimize m2 staples that can't via down to m1.
    TODO: with additional power & ground domains, it will need to parse the domain boundaries. If more than 1 ground is allowed, the bottommost m1 stripe may be the wrong net.
    """
    bottom_strap_layer = ht.get_setting("par.generate_power_straps_options.by_tracks.strap_layers")[0]
    assert bottom_strap_layer == "m3", "Lowest user-specified strap layer must be m3 in order for post-power straps m2 stapling to work."
    ht.logger.info("intech22_m2_staples requires the intech22_create_sites hook. Double-check to see that you have not removed intech22_create_sites.")
    p_nets = list(map(lambda s: s.name, ht.get_independent_power_nets()))
    g_nets = list(map(lambda s: s.name, ht.get_independent_ground_nets()))
    site_height = ht.technology.get_placement_site().y
    ht.append('''
    reset_db -category add_stripes
    set_db add_stripes_use_fgc true
    set_db add_stripes_stacked_via_top_layer m2
    set_db add_stripes_stacked_via_bottom_layer m2
    set_db add_stripes_trim_antenna_back_to_shape {{stripe}}
    set_db add_stripes_spacing_from_block {spacing}
    # First place bottommost m1 ground stripe (missed with -over_pins)
    add_stripes -layer m1 -nets {g_net} -block_ring_bottom_layer_limit m1 -block_ring_top_layer_limit m1 -pad_core_ring_bottom_layer_limit m1 -pad_core_ring_top_layer_limit m1 -direction horizontal -width 0.044 -start_offset 0.608 -number_of_sets 1
    '''.format(spacing=ht.get_setting("par.blockage_spacing"), g_net=g_nets[0]), clean=True)

    # TODO: try to use update_power_vias to drastically speed this up
    ht.append('''
    # Next draw m2 pg stripes directly over m1 stripes and place vias
    add_stripes -layer m2 -nets {{ {nets} }} -block_ring_bottom_layer_limit m2 -block_ring_top_layer_limit m2 -pad_core_ring_bottom_layer_limit m2 -pad_core_ring_top_layer_limit m2 -direction horizontal -width 0.044 -start_offset 0.608 -spacing 0.586 -set_to_set_distance 1.26
    set pullback(m2) 0.080
    set v1_pitch 0.216
    # Offset if core area is not exact multiple of 0.108
    set core_os [convert_dbu_to_um [expr [convert_um_to_dbu [get_db designs .core_bbox.ll.x]] % [convert_um_to_dbu 0.108]]]
    foreach net {{ {nets} }} {{
    '''.format(nets=" ".join(g_nets + p_nets)), clean=True)
    ht.append('''
        set m2_net_bboxes [get_db [get_db [get_db nets $net] .special_wires -if {.layer.name == m2}] .rect]
        if { [llength $m2_net_bboxes] > 0 } {
            foreach m2_net_bbox $m2_net_bboxes {
                #create_shape -layer m2 -net $net -rect $m2_net_bbox -shape stripe
                set llx [lindex $m2_net_bbox 0]
                set lly [lindex $m2_net_bbox 1]
                set urx [lindex $m2_net_bbox 2]
                set ury [lindex $m2_net_bbox 3]
                set x [expr $llx - $pullback(m2) + $v1_pitch - 0.028]
                set x [expr [convert_um_to_dbu $x] / [convert_um_to_dbu $v1_pitch]]
                set x [expr [expr $x * $v1_pitch] - $pullback(m2) + $v1_pitch + $v1_pitch - 0.028 + $core_os]
                set y [expr $lly + 0.022]
                while { $x <= [ expr [lindex $m2_net_bbox 2] - $v1_pitch] } {
               	    create_via -location "{$x $y}" -net $net -via_def VIA1_60SX44_68V_44H
               	    set x [expr {$x + $v1_pitch}]
                }
            }
        } else {}
    }
    ''', clean=True)
    ht.append('''
    select_routes -layer {{ m2 m3 }} -nets {{ {pg_nets} }} -shapes stripe
    update_power_vias -add_vias 1 -between_selected_wires 1 -skip_via_on_pin {{}}
    deselect_routes
    add_power_mesh_colors
    '''.format(pg_nets=" ".join(p_nets + g_nets)), clean=True)
    return True

def intech22_reference_power_straps(ht: HammerTool) -> bool:
    assert isinstance(ht, HammerPlaceAndRouteTool), "Innovus settings only for par"
    """
    DO NOT USE: requires "VDD & VSS" power nets and is very dense. Also, straps will spill over beyond the bounds of the core box.
    Places stacked m1-m2-m4-m6 stripes at every site height pitch.
    Places stacked m3-m5-m7 stripes at some small multiple of site width pitch.
    Adapted from pg_insertion.tcl and procs.tcl in Intel Reference Flow for be2 stackup only.
    """
    if ht.get_setting("technology.core.stackup") != "be2":
        self.logger.error("Cannot use intech22_reference_power_straps hook except in be2 stackup.")
    ht.append('''
######################################################################################
################ Procedure to add stripes#############################################
######################################################################################

proc user_generate_power_stripes { stripe_generation_template power_net_name} {
  set_db add_stripes_skip_via_on_pin {}
  set lef_layer_list [get_db [get_db layers -if {.type == routing}] .name]

  foreach stripe_to_generate $stripe_generation_template {
    set stripe_layer_direction [lindex $stripe_to_generate 1]
    set stripe_layer_name [lindex $stripe_to_generate 0]
    set stripe_layer_number [regsub "m" [lindex [split $stripe_layer_name "_"] 0] "" ]
    if { $stripe_layer_number <= 7 } {
                                 #$vars(max_pg_layer)
       puts "$stripe_layer_number"
       set stripe_layer_offset [lindex $stripe_to_generate 2]
       set stripe_layer_width [lindex $stripe_to_generate 3]
       set stripe_layer_period [lindex $stripe_to_generate 4]

      ##Stapling of m3 on dot3 tall flow
      if {$stripe_layer_name eq "m3_dot3_df0" || $stripe_layer_name eq "m3_dot6_df0"} {
      ## Adding the M3 PG staples
        set stripe_layer_name "m3"
        set lef_layer_index [lsearch -exact $lef_layer_list $stripe_layer_name]

      if {$lef_layer_index < 0 } {
          set stripe_lower_layer_name $stripe_layer_name
          set stripe_upper_layer_name $stripe_layer_name
          puts " ## INFO ## Cant find the layer specified in the template."
          puts " ## INFO ## Check the names of the layer in the TECH LEF against the template layer names"
      } else {
          set stripe_lower_layer_name [lindex $lef_layer_list [expr $lef_layer_index - 1]]
          set stripe_upper_layer_name [lindex $lef_layer_list [expr $lef_layer_index + 1]]
      }

      puts " ## Adding the M3 PG Staples. "

      ## Defining the length of the VSS/VDD staples
      set length_VSS 0.616
      set length_VDD 0.616

      ## Defining the starting co-ordinates for the VSS/VDD staples
      set VSS_x 0.810
      set VSS_y 1.036
      set VDD_x 0.810
      set VDD_y 0.364

      ## Defining the Pitch of the VSS/VDD staples
      set x_offset 0.840
      set y_offset 1.344

      puts " ## INFO ## Adding $power_net_name stapled stripe between layers $stripe_layer_name & $stripe_lower_layer_name"

      set_db add_stripes_stacked_via_top_layer ${stripe_upper_layer_name}
      set_db add_stripes_stacked_via_bottom_layer ${stripe_lower_layer_name}
          ##Add condition to change the core area if the metal layer is below m4
          # Headers and Template
      scan [get_db designs .core_bbox] "{%f %f %f %f}" _llx _lly _urx _ury
      if {$power_net_name eq "VDD"} {
        for { set y $VDD_y} {[expr $y + $y_offset/2] < $_ury} { set y [expr $y + $y_offset]} {
          add_stripes -max_same_layer_jog_length 0 -set_to_set_distance $x_offset \
              -spacing $x_offset -x_left_offset $VDD_x -layer ${stripe_layer_name} -width ${stripe_layer_width} \
              -nets $power_net_name -direction vertical -area [list $_llx $y $_urx [expr $y + $length_VDD]]
        }
      } elseif {$power_net_name eq "VSS"} {
        for { set y $VSS_y} {[expr $y + $y_offset/2] < $_ury} { set y [expr $y + $y_offset]} {
          add_stripes -max_same_layer_jog_length 0 -set_to_set_distance $x_offset \
              -spacing $x_offset -x_left_offset $VSS_x -layer ${stripe_layer_name} -width ${stripe_layer_width} \
              -nets $power_net_name -direction vertical -area [list $_llx $y $_urx [expr $y + $length_VSS]]
        }

      }

} else {
if { $stripe_layer_name eq "m4_dot6" } {
   set stripe_layer_name "m4"
   if { $stripe_layer_width == 0.084 } {
    set_db generate_special_via_rule_preference default
    set VSS_via_preference_list [list VIA2O_40 VIA2O_74 VIA3O_84 VIA4U_84 VIA5L_76 VIA6F_108 VIA7GS_168 VIA8JS_264 VIA9RA_PG RVIA10 SVIA11]
    set_db generate_special_via_rule_preference $VSS_via_preference_list
    set_db generate_special_via_rule_preference default
    set VDD_via_preference_list [list VIA2O_40 VIA2O_74 VIA3O_84 VIA4U_84 VIA5L_76 VIA6F_108 VIA7GS_168 VIA8JS_264 VIA9RA_PG RVIA10 SVIA11]
    set_db generate_special_via_rule_preference $VDD_via_preference_list
  } elseif { $stripe_layer_width == 0.076 } {
    set_db generate_special_via_rule_preference default
    set VSS_via_preference_list [list VIA2S_76 VIA2O_74 VIA3S_84 VIA4U_76 VIA5L_76 VIA6F_108 VIA7GS_168 VIA8JS_264 VIA9RA_PG RVIA10 SVIA11]
    set_db generate_special_via_rule_preference $VSS_via_preference_list
    set_db generate_special_via_rule_preference default
    set VDD_via_preference_list [list VIA2S_76 VIA2O_74 VIA3S_84 VIA4U_76 VIA5L_76 VIA6F_108 VIA7GS_168 VIA8JS_264 VIA9RA_PG RVIA10 SVIA11]
    set_db generate_special_via_rule_preference $VDD_via_preference_list
}
} elseif { $stripe_layer_name eq "m4_dot3" } {
    set stripe_layer_name "m4"
	if { $stripe_layer_width == 0.084 } {

        set_db generate_special_via_rule_preference default
        set VSS_via_preference_list [list VIA2O_74 VIA3O_84 VIA4O_84 VIA5MP_84 VIA6F_108 VIA7ZT_2x1 VIA8B_468_1080]
        set_db generate_special_via_rule_preference $VSS_via_preference_list
        set_db generate_special_via_rule_preference default
        set VDD_via_preference_list [list VIA2O_74 VIA3O_84 VIA4O_84 VIA5MP_84 VIA6F_108 VIA7ZT_2x1 VIA8B_468_1080]
        set_db generate_special_via_rule_preference $VDD_via_preference_list
      } elseif { $stripe_layer_width == 0.076 } {
        set_db generate_special_via_rule_preference default
        #set VSS_via_preference_list [list VIA2C VIA3S VIA4O VIA5MP VIA6F VIA8B_468_1080]
        set VSS_via_preference_list [list VIA2O_74 VIA3S_84 VIA4O_76 VIA5MP_84 VIA6F_108 VIA7ZT_2x1 VIA8B_468_1080]
        set_db generate_special_via_rule_preference $VSS_via_preference_list
        set_db generate_special_via_rule_preference default
        set VDD_via_preference_list [list VIA2O_74 VIA3S_84 VIA4O_76 VIA5MP_84 VIA6F_108 VIA7ZT_2x1 VIA8B_468_1080]
        set_db generate_special_via_rule_preference $VDD_via_preference_list
      }
}

## Code to query the lower metal layer w.r.t to current layer on which stripe is being added
    #set lef_layer_list [get_db [get_db layers -if {.type == routing}] .name]
    set lef_layer_index [lsearch -exact $lef_layer_list $stripe_layer_name]

    if {$lef_layer_index < 0 } {
      set stripe_lower_layer_name $stripe_layer_name
      set stripe_upper_layer_name $stripe_layer_name
      puts " ## INFO ## Cant find the layer specified in the template."
      puts " ## INFO ## Check the names of the layer in the TECH LEF against the template layer names"
    } else {
      set stripe_lower_layer_name [lindex $lef_layer_list [expr $lef_layer_index - 1]]
      set stripe_upper_layer_name [lindex $lef_layer_list [expr $lef_layer_index + 1]]

    }

    ## Adding stripes based on the conditions
    if {$stripe_layer_direction eq "vertical"} {

      puts " ## INFO ## Adding $power_net_name stripe between layers $stripe_upper_layer_name & $stripe_lower_layer_name"
      set_db add_stripes_stacked_via_top_layer ${stripe_upper_layer_name}
      set_db add_stripes_stacked_via_bottom_layer ${stripe_lower_layer_name}

      add_stripes -block_ring_top_layer_limit ${stripe_layer_name} \
          -max_same_layer_jog_length 0 \
          -pad_core_ring_bottom_layer_limit ${stripe_layer_name} \
          -set_to_set_distance ${stripe_layer_period} \
          -pad_core_ring_top_layer_limit ${stripe_layer_name} \
          -spacing ${stripe_layer_period} \
          -start_offset ${stripe_layer_offset} \
          -layer ${stripe_layer_name} \
          -block_ring_bottom_layer_limit ${stripe_layer_name} \
          -width ${stripe_layer_width} \
          -nets $power_net_name \
          -direction vertical \
          -create_pins 1
    } else {

      puts " ## INFO ## Adding $power_net_name stripe between layers $stripe_upper_layer_name & $stripe_lower_layer_name"
      set_db add_stripes_stacked_via_top_layer ${stripe_upper_layer_name}
      set_db add_stripes_stacked_via_bottom_layer ${stripe_lower_layer_name}

      add_stripes -block_ring_top_layer_limit ${stripe_layer_name} \
          -max_same_layer_jog_length 0 \
          -pad_core_ring_bottom_layer_limit ${stripe_layer_name} \
          -set_to_set_distance ${stripe_layer_period} \
          -pad_core_ring_top_layer_limit ${stripe_layer_name} \
          -spacing ${stripe_layer_period} \
          -start_offset ${stripe_layer_offset} \
          -layer ${stripe_layer_name} \
          -block_ring_bottom_layer_limit ${stripe_layer_name} \
          -width ${stripe_layer_width} \
          -nets $power_net_name \
          -direction horizontal \
          -create_pins 1
      }
    }
   }
  }
 set_db add_stripes_skip_via_on_pin standardcell
 }

##################################PG INSERTION TEMPLATES SPECIFIC TO DOT PROCESSES###################
#####################################################################################################

proc initialize_power_stripe_templates_dot2_8m_108 { } {
## Templates
global VSS_power_stripe_generation_template_dot2_8m_108
global VDD_power_stripe_generation_template_dot2_8m_108

# power stripe fields: offset, width, period # added anshul

  set VSS_power_stripe_generation_template_dot2_8m_108 [list \
                                                "m2 horizontal 0.608 0.044  1.260" \
                                                "m3 vertical   1.058 0.044  1.080" \
                                                "m4 horizontal 1.238 0.044  1.260" \
                                                "m5 vertical   1.058 0.044  1.080" \
                                                "m6 horizontal 2.440 0.160  2.520" \
                                                "m7 vertical   3.780 1.080  4.320" \
                                           ]

  set VDD_power_stripe_generation_template_dot2_8m_108 [list \
                                                "m2 horizontal 1.238 0.044  1.260" \
                                                "m3 vertical   0.518 0.044  1.080" \
                                                "m4 horizontal 0.608 0.044  1.260" \
                                                "m5 vertical   0.518 0.044  1.080" \
                                                "m6 horizontal 1.180 0.160  2.520" \
                                                "m7 vertical   1.620 1.080  4.320" \
                                           ]

}

proc generate_all_power_stripes { dotProcess } {

  global VSS_power_stripe_generation_template_dot2_8m_108
  global VDD_power_stripe_generation_template_dot2_8m_108
  global xnOffset

  set prc_node $dotProcess

  ## Common options
  # Set the 0.00 offset for the short case
  set xnOffset 0.0

  # Documentation on this option is all wrong, also obsolete
  #set_db generate_special_via_create_double_row_cut_via add_extra_cut
  #set_db generate_special_via_create_max_row_cut_via true
  set_db generate_special_via_opt_cross_via true
  set_db add_stripes_remove_floating_stripe_over_block false
  #Allow DRC Checks to flag and fix VIA drop issues at closed intersections over Macro
  set_db generate_special_via_ignore_drc false
  set_db add_stripes_ignore_drc false


  set pwStripeStapling 1
  delete_all_power_preroutes

#Create Macro  and Top Level Blockages
			set even_layers "m2 m4 m6"
			set odd_layers  "m3 m5 m7"

            #P_top_pg_blockage $even_layers $odd_layers

			#P_macro_pg_blkg $even_layers $odd_layers

			# Template Initialization
			initialize_power_stripe_templates_dot2_8m_108

#                        set VSS_via_preference_list [list VIA1_60SX44_68V_44H_DA VIA2_44X58S_44H_44V VIA3_58SX44_44V_44H VIA4_44X58S_44H_44V VIA5_58SX160_44V_160H VIA6_400X120_160H_540V]
 #                       set VDD_via_preference_list [list VIA1_60SX44_68V_44H_DA VIA2_44X58S_44H_44V VIA3_58SX44_44V_44H VIA4_44X58S_44H_44V VIA5_58SX160_44V_160H VIA6_400X120_160H_540V]

		        set VSS_via_preference_list [list VIA1_60SX44_44H_44H VIA2_44X58S_44H_44V VIA3_58SX44_44V_44H VIA4_44X58S_44H_44V VIA5_58SX160_44V_160H VIA6_400X120_160H_540V]
                set VDD_via_preference_list [list VIA1_60SX44_44H_44H VIA2_44X58S_44H_44V VIA3_58SX44_44V_44H VIA4_44X58S_44H_44V VIA5_58SX160_44V_160H VIA6_400X120_160H_540V]

			### VSS section
            set_db generate_special_via_rule_preference default
            set_db generate_special_via_rule_preference $VSS_via_preference_list
			user_generate_power_stripes $VSS_power_stripe_generation_template_dot2_8m_108 "VSS"
                                                                                                #$vars(ground_nets)

			### VDD section
            set_db generate_special_via_rule_preference default
            set_db generate_special_via_rule_preference $VDD_via_preference_list
			user_generate_power_stripes $VDD_power_stripe_generation_template_dot2_8m_108 "VDD"
                                                                                                #$vars(power_nets)

			##Clean up the Created PG blockages
			#Not needed for dot2 - editDeleteVia options
		    #clean_up_vias

			##Delete Route Blks
			delete_route_blockages -name pgGridBlk
}

#Create Routing Blockages within the Top Level design
#1) Routing Blockages are created for the Layers specified below from the Top Level Boundaries
#2) The Generated Stripes are then pulled back from the Top Level Boundaries appropriately with the below Specfied Value
set pullback(m2) 0.080
set pullback(m3) 0.080
set pullback(m4) 0.080
set pullback(m5) 0.080
set pullback(m6) 0.080

 ## Calling the function for Creating stripes
set INTEL_DOTP "dot2"
generate_all_power_stripes $INTEL_DOTP

# For horizontal power starp ( VDD and VSS) of m1 and via between m1 and m2
set_db add_stripes_stacked_via_top_layer m2
set_db add_stripes_stacked_via_bottom_layer m1
set nets {VDD VSS}
# Delete any v1's that may have been created above
select_vias -cut_layer v1 -nets $nets
delete_selected
foreach net $nets {
	set m2_net_bboxes [get_db [get_db [get_db nets $net] .special_wires -if {.layer.name == m2}] .rect]
	if { [llength $m2_net_bboxes] > 0 } {
		foreach m2_net_bbox $m2_net_bboxes {
			create_shape -layer m1 -net $net -rect $m2_net_bbox -shape stripe
			set llx [lindex $m2_net_bbox 0]
			set lly [lindex $m2_net_bbox 1]
			set urx [lindex $m2_net_bbox 2]
			set ury [lindex $m2_net_bbox 3]
			#set x [expr $llx - $pullback(m2) + 0.216 + 0.078 - 0.030 + 0.060]
			set x [expr $llx - $pullback(m2) + 0.216 - 0.030 + 0.002]
			set x [expr [convert_um_to_dbu $x] / [convert_um_to_dbu 0.216]]
			set x [expr [expr $x * 0.216] - $pullback(m2) + 0.216 + 0.216 - 0.030 + 0.002]
			set y [expr $lly + 0.022]
			while { $x < [ expr [lindex $m2_net_bbox 2] - 0.1] } {
				create_via -location "{$x $y}" -net $net -via_def VIA1_60SX44_68V_44H
				set x [expr {$x + 0.216}]
			}
		}
	} else {}
}
set_db [get_db [get_db nets -if {.vias.name == VIA1_60SX44_68V_44H}] .vias] .shape followpin

# Reset via preferences
set_db generate_special_via_rule_preference default
    ''', clean=True)
    return True

def intech22_cts_options(ht: HammerTool) -> bool:
    assert isinstance(ht, HammerPlaceAndRouteTool), "Innovus settings only for par"
    """
    Adapted from cts_options.tcl in Intel Reference Flow.
    """
    if ht.hierarchical_mode.is_nonleaf_hierarchical():
        ht.append('flatten_ilm')
    ht.append('''
    #================================================================
    # choose native ccopt
    #================================================================
    set_limited_access_feature ccopt_native 1
    set_db cts_integration native

    #================================================================
    # clkbuf padding (from other clkbufs):
    #================================================================
    set_db cts_cell_density 0.5
    set_db cts_adjacent_rows_legal false

    #ccopt
    set cts_top_target_slew    100
    set cts_leaf_target_slew   100
    set cts_trunk_target_slew        100

    #================================================================
    # potentially useful knobs (design dependent):
    #================================================================
    set_db ccopt_skew_band_size 4.0
    set_db ccopt_min_delta_band_factor 0.021
    set_db ccopt_skew_pass_sufficient_progress_band_size_factor 0.1
    set_db ccopt_useful_skew_recluster_push_clock_gates_into_windows true
    set_db ccopt_run_latch_sta_during_slack_update false
    set_db ccopt_skew_passes_per_band 10
    set_db ccopt_auto_limit_insertion_delay_factor 1.2

    #================================================================
    # Following command ensures that the IN_PORT_DIODE's do not get
    # considered as sinks during ccopt.
    #================================================================
    foreach_in_collection pins [get_pins IN_PORT_DIODE*/a] {{
      set_db $pin .cts_sink_type exclude
    }}

    #===============================================================
    # implementation of create_route type to enable NDR's
    # Design specific and allows routing Leaf/Trunk with NDR Values
    # The following creates a route_type with NDR - ndr_wideW_m6_m7_m8_noSh routes (OR) ndr_defaultW_3T_Sh routes
    #===================================================================
    set NDR_bottom_preferred_layer 4
    set NDR_top_preferred_layer 6
    set clock_leaf_bottom_preferred_layer 3
    set clock_leaf_top_preferred_layer 5
    set ground_nets {ground_nets}
    '''.format(ground_nets=" ".join(map(lambda s: s.name, ht.get_independent_ground_nets()))), clean=True)

    ht.append('''
    add_tracks -width_pitch_pattern {\
	{m1 offset 0.0 width 0.068 pitch 0.108} \
	{m2 offset 0.0 width 0.044 pitch 0.090} \
	{m3 offset 0.0 width 0.044 pitch 0.090} \
	{m4 offset 0.0 width 0.044 pitch 0.090} \
	{m5 offset 0.0 width 0.044 pitch 0.090} \
	{m6 offset 0.0 width 0.044 pitch 0.090} \
	{m7 offset 0.0 width 0.180 pitch 0.360} \
        {m8 offset 0.0 width 0.180 pitch 0.360} \
    }''')

    ht.append('puts "INFORMATION : No NDR Rule is specified for clock nets. Default Route setting will be used."')
    ht.append('''
    #===============================================================
    # apply above rule(s) to clock nets based on trasitive fanout
    # this is a global setting
    # other setting will follow that define nets as either top/trunk/leaf
    # and based on the net_type (in this case top)
    #===============================================================
    set_db cts_top_fanout_threshold 7000

    #===============================================================
    # establish a general slew target:
    # below we are using "default" setting for the clock skew.
    #===============================================================
    set_db cts_target_skew default

    #=======================================================
    # for ccopt -cts version. Shown as example
    #=======================================================
    set_db cts_target_max_transition_time_top 100
    set_db cts_target_max_transition_time_leaf 100
    set_db cts_target_max_transition_time_trunk 100

    #=======================================================
    # define buffers and inverters
    #=======================================================
    set_db opt_fix_hold_lib_cells   "b15bfm201al1n02x5 b15bfm201al1n04x5 b15bfm201al1n08x5 b15bfm201al1n16x5 b15bfm402al1n02x5 b15bfm402al1n04x5 b15bfm402al1n08x5 b15bfm402al1n08x5 b15bfn000al1n03x5 b15bfn000al1n04x5 b15bfn000al1n06x5"

    set_db cts_buffer_cells "b15cbf000ah1n48x5 b15cbf000ah1n64x5 b15cbf000ah1n32x5 b15cbf000ah1n16x5 b15cbf000ah1n24x5 b15cbf000al1n64x5 b15cbf000al1n16x5 b15cbf000al1n48x5 b15cbf000al1n32x5 b15cbf000al1n24x5 b15cbf000am1n24x5 b15cbf000am1n48x5 b15cbf000am1n32x5 b15cbf000am1n64x5 b15cbf000am1n16x5 b15cbf000an1n64x5 b15cbf000an1n32x5 b15cbf000an1n24x5 b15cbf000an1n16x5 b15cbf000an1n48x5"

    set_db cts_inverter_cells " b15cinv00ah1n02x5 b15cinv00ah1n03x5 b15cinv00ah1n04x5 b15cinv00ah1n06x5 b15cinv00ah1n08x5 b15cinv00ah1n12x5 b15cinv00ah1n16x5 b15cinv00ah1n20x5 b15cinv00ah1n24x5 b15cinv00ah1n28x5 b15cinv00ah1n32x5 b15cinv00ah1n40x5 b15cinv00ah1n48x5 b15cinv00ah1n56x5 b15cinv00ah1n64x5 b15cinv00ah1n80x5 b15cinv00al1n02x5 b15cinv00al1n03x5 b15cinv00al1n04x5 b15cinv00al1n06x5 b15cinv00al1n08x5 b15cinv00al1n12x5 b15cinv00al1n16x5 b15cinv00al1n20x5 b15cinv00al1n24x5 b15cinv00al1n28x5 b15cinv00al1n32x5 b15cinv00al1n40x5 b15cinv00al1n48x5 b15cinv00al1n56x5 b15cinv00al1n64x5 b15cinv00al1n80x5 b15cinv00am1n02x5 b15cinv00am1n03x5 b15cinv00am1n04x5 b15cinv00am1n06x5 b15cinv00am1n08x5 b15cinv00am1n12x5 b15cinv00am1n16x5 b15cinv00am1n20x5 b15cinv00am1n24x5 b15cinv00am1n28x5 b15cinv00am1n32x5 b15cinv00am1n40x5 b15cinv00am1n48x5 b15cinv00am1n56x5 b15cinv00am1n64x5 b15cinv00am1n80x5 b15cinv00an1n02x5 b15cinv00an1n03x5 b15cinv00an1n04x5 b15cinv00an1n06x5 b15cinv00an1n08x5 b15cinv00an1n12x5 b15cinv00an1n16x5 b15cinv00an1n20x5 b15cinv00an1n24x5 b15cinv00an1n28x5 b15cinv00an1n32x5 b15cinv00an1n40x5 b15cinv00an1n48x5 b15cinv00an1n56x5 b15cinv00an1n64x5 b15cinv00an1n80x5"

    set_db cts_clock_gating_cells   " b15cilb01ah1n24x5 b15cilb01ah1n48x5 b15cilb01ah1n16x5 b15cilb01ah1n64x5 b15cilb01ah1n32x5 b15cilb01am1n48x5 b15cilb01am1n64x5 b15cilb01am1n32x5 b15cilb01am1n24x5 b15cilb01am1n16x5 b15cilb01hl1n16x5 b15cilb01hl1n24x5 b15cilb01hl1n64x5 b15cilb01hl1n32x5 b15cilb01hl1n48x5 b15cilb01hn1n48x5 b15cilb01hn1n16x5 b15cilb01hn1n32x5 b15cilb01hn1n24x5 b15cilb01hn1n64x5"

    #=======================================================
    # tell the tool whether to use inverters or not
    #=======================================================
    set_db cts_use_inverters auto

    #=======================================================
    # tell ccopt what to do with cloning of clock gates
    # also what to do about clock_gate related logic
    #=======================================================
    set_db cts_clone_clock_gates true
    set_db cts_clone_clock_logic true

    #=======================================================
    # tell Ccopt to merge clock gates and also to merge clock logic
    #=======================================================
    set_db ccopt_merge_clock_gates true
    set_db ccopt_merge_clock_logic true

    #=======================================================
    # tell ccopt to update the io constraints, if this is a block
    # read documentation from cadence about this setting.
    # it will update io constaints based on skew generated.
    # clock must NOT BE propogated for this to work correctly
    #=======================================================.
    set_db cts_update_clock_latency true

    set_db opt_unfix_clock_insts false
    set_db opt_useful_skew_ccopt standard
    set_db opt_useful_skew_post_route false
    set_db cts_fix_clock_sinks true
    ''', clean=True)
    return True

def intech22_add_fillers(ht: HammerTool) -> bool:
    assert isinstance(ht, HammerPlaceAndRouteTool), "Innovus settings only for par"
    """
    Tech-specific filler insertion. Based on filler_cell_insertion.tcl from Intel Reference Flow.
    """
    stdfiller = " ".join(list(map(lambda cell: str(cell), ht.technology.get_special_cell_by_type(CellType.StdFiller)[0].name)))
    ht.append('''
    set decap_cells  "b15qgbdcpan1n64x5 b15qgbdcpan1n32x5 b15qgbdcpan1n16x5 b15qgbdcpan1n08x5 b15qgbdcpan1n04x5"
    set bonus_gatearray_cells "b15qgbar1ah1n04x5 b15qgbar1ah1n08x5 b15qgbar1ah1n16x5 b15qgbar1ah1n32x5 b15qgbar1ah1n64x5 b15qgbar1al1n04x5 b15qgbar1al1n08x5 b15qgbar1al1n16x5 b15qgbar1al1n32x5 b15qgbar1al1n64x5 b15qgbar1am1n04x5 b15qgbar1am1n08x5 b15qgbar1am1n16x5 b15qgbar1am1n32x5 b15qgbar1am1n64x5 b15qgbar1an1n04x5 b15qgbar1an1n08x5 b15qgbar1an1n16x5 b15qgbar1an1n32x5 b15qgbar1an1n64x5"
    add_fillers -density 0.5 -base_cells "$decap_cells"
    add_fillers -density 0.5 -base_cells "$bonus_gatearray_cells"
    set_db add_fillers_cells "{spacer_cells}"
    add_fillers
    '''.format(spacer_cells=stdfiller), clean=True)
    return True

def intech22_extra_layers(ht: HammerTool) -> bool:
    assert isinstance(ht, HammerPlaceAndRouteTool), "Innovus settings only for par"
    """
    Creates extra layers needed for tapeout.
    1. DIEAREA rectangle aligned with design boundary for density DRC
    2. Edge of Active (EOA) placed if die ring template is instantiated (does not work for custom die rings)
    3. GLOBALFILLKOR placed over the ER, EDM, & PRS cells if a die ring template is instantiated (does not work for custom die rings)
    4. DiffCheck grid in core bbox (cut out over hard macros except die ring template, only supports rectangular floorplan)
    5. Delete all route blockages (otherwise, fill will not work)
    Adapted from die_ring/fc_tool.tcl and create_check_grid.tcl in Intel Reference Flow.
    """
    ht.append('''
    # Instantiate DIEAREA rectangle
    create_shape -layer DIEAREA -user_class 0 -rect [get_db designs .bbox]

    # Block the die ring if overlap DR cell has been pushed through.  
    if {[get_db insts -if {.base_cell == *uni2_2x2*er_edm_prs_top_cnr}] != ""} {
        # Extract information regarding the package. 
        set dr_db [get_db insts -if {.base_cell == *uni2_2x2*er_edm_prs_top_cnr}]
        set dr_w [get_db $dr_db .bbox.ur.x]
        set dr_h [get_db $dr_db .bbox.ur.y]
        set ll_x 17.28
        set ll_y 18.9
        set brdr_x 39.96
        set brdr_y 40.32
        set ur_x [expr $dr_w - $brdr_x]
        set ur_y [expr $dr_h - $brdr_y]

        # Create a square EOA.
        create_shape -layer eoa -user_class 29 -rect [list $ll_x $ll_y $ur_x $ur_y]
        
        # Create GLOBALFILLKOR.
        set prs_w 75.6
        set prs_h 76.86
 
        create_shape -layer GLOBALFILLKOR -user_class 93 -rect [list 0 0 $dr_w $ll_y]
        create_shape -layer GLOBALFILLKOR -user_class 93 -rect [list 0 $ll_y $ll_x $dr_h]
        create_shape -layer GLOBALFILLKOR -user_class 93 -rect [list $ll_x $ur_y $dr_w $dr_h]
        create_shape -layer GLOBALFILLKOR -user_class 93 -rect [list $ur_x $ll_y $dr_w $ur_y]
        create_shape -layer GLOBALFILLKOR -user_class 93 -rect [list 0 0 $prs_w $prs_h]
        
    } elseif {[get_db insts -if {.base_cell == *uni2_4x4*er_edm_prs_top}] != ""} {
        # Extract information regarding the package. 
        set dr_db [get_db insts -if {.base_cell == *uni2_4x4*er_edm_prs_top}]
        set dr_w [get_db $dr_db .bbox.ur.x]
        set dr_h [get_db $dr_db .bbox.ur.y]
        set ll_x 16.2
        set ll_y 17.6555
        set ur_x [expr $dr_w - $ll_x]
        set ur_y [expr $dr_h - $ll_y]

        # Create a square EOA.
        create_shape -layer eoa -user_class 29 -rect [list $ll_x $ll_y $ur_x $ur_y]

        # Create GLOBALFILLKOR.
        set prs_w 74.52
        set prs_h 75.6
        set prs_ll_x [expr $dr_w - $prs_w]
        set prs_ll_y [expr $dr_h - $prs_h]

        create_shape -layer GLOBALFILLKOR -user_class 93 -rect [list 0 0 $dr_w $ll_y]
        create_shape -layer GLOBALFILLKOR -user_class 93 -rect [list 0 $ur_y $dr_w $dr_h]
        create_shape -layer GLOBALFILLKOR -user_class 93 -rect [list 0 $ll_y $ll_x $ur_y]
        create_shape -layer GLOBALFILLKOR -user_class 93 -rect [list $ur_x $ll_y $dr_w $ur_y]
        create_shape -layer GLOBALFILLKOR -user_class 93 -rect [list 0 0 $prs_w $prs_h]
        create_shape -layer GLOBALFILLKOR -user_class 93 -rect [list $prs_ll_x $prs_ll_y $dr_w $dr_h]
    }

    # Create diffCheck grid with cutouts around hardmacros (assumed to be anything >4 sites tall)
    set step 0.090
    set width 0.031
    set start 0.0745
    set stop 0.0745
    set hardmacro_height [expr [get_db designs .core_site.size.y] * 4]
    scan [get_db designs .core_bbox] "{%f %f %f %f}" b_llx b_lly b_urx b_ury
    set loop_counter_y [expr $start + $b_lly]
    puts "Adding diffCheck stripes starting at $loop_counter_y"
    while { $loop_counter_y < [expr $b_ury - $stop] } {
        create_shape -layer diffCheck -rect [list $b_llx $loop_counter_y $b_urx [expr $loop_counter_y + $width]]
        set loop_counter_y [expr $loop_counter_y + $step]
    }
    
    if {[get_db insts -if {.base_cell == *uni2_2x2*er_edm_prs_top_cnr}] != ""} {
        puts "Manually adding in one extra diff check object for UNI2x2!"
        create_shape -layer diffCheck -rect [list 17.28 2002.1245 1922.4 2002.1555]
    } 
    
    puts "Finished adding diffCheck stripes at $loop_counter_y"

    # Remove user shapes over HIP/DIC
    ## Assuming all objects > 4x std.cell height to be macros
    ## Do not match on insts that are outside the core bbox
    foreach i [get_db insts] {
        if { $i != "0x0" } {
            set boxVal [get_db $i .overlap_rects]
            if { [get_db $i .base_cell.bbox.dy] > $hardmacro_height && [get_computed_shapes $boxVal INSIDE [get_db designs .core_bbox]] != "" } {
                puts "Carving out grid check over [get_db $i .name]"
                set boxVal [get_db $i .overlap_rects]
                # swires in area {bbox_llx boxVal_lly bbox_urx boxVal_ury}
                select_routes -area $b_llx [get_db $boxVal .ll.y] $b_urx [get_db $boxVal .ur.y] -layer diffCheck -type special
                edit_cut_route -selected -box $boxVal
                deselect_routes
                delete_routes -layer diffCheck -net _NULL -area $boxVal
            }
        }
    }

    # Delete route blockages
    delete_route_blockages -type all
    ''', clean=True)
    return True
