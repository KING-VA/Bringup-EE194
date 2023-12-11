# --------------------------------
# FINISHING 2x2 SCRIPT
# last Modified: 02/02/23, Ken H
# --------------------------------

set standalone_output_path [lindex $argv 0]
set combined_output_path [lindex $argv 1]
set chip_path [lindex $argv 2]
set base_fill_path [lindex $argv 3]
set metal_fill_path [lindex $argv 4]
set dr_path [lindex $argv 5]

set cell_package [lindex $argv 6]
set cell_quadrant [lindex $argv 7]
set cell_bump [lindex $argv 8]

set layer_globalfillkor 255.93
set layer_prboundary 50

set lay layout0
set lay1 layout1
set lay2 layout2

# Blockage/ PR boundary/ DEVFLAV layers must be specified so that they may be resized.
# .93 end are blockage object layers. 273.1 is devflav.
set layer_base_bfill {1.93 2.93 5.93 6.93 8.93 273.1} 
set layer_metal_bfill {4.93 13.93 14.93 17.93 18.93 21.93 22.93 25.93 26.93 29.93 30.93 33.93 34.93 37.93 38.93 41.93 \
90.93 91.93 257.93 258.93 259.93 344.93 346.93} 

set name_top_new 8su722v_dot4opt1_0a_UCB1222
#---------------------------------------------------------------
# PREPARING UN-PLACED SINGLE SUBMISSION
#---------------------------------------------------------------
# Expand the DT sub-layers, preserve attributes and properties.
layout create $lay $chip_path -dt_expand -preserveProperties -preserveTextAttributes
layout create $lay1 $base_fill_path -dt_expand -preserveProperties -preserveTextAttributes
layout create $lay2 $metal_fill_path -dt_expand -preserveProperties -preserveTextAttributes

# Vertices of quadrant pin.
set vertices_qp [$lay iterator poly $cell_quadrant $layer_prboundary range 0 end] 
set vertices_qp [lreplace [lindex $vertices_qp 0] 0 0]

# Delete the package, bumps, and blockages. 
$lay delete cell $cell_package -deleteChildCells
$lay delete cell $cell_bump -deleteChildCells
$lay delete polygons [$lay topcell] $layer_globalfillkor
$lay delete polygons [$lay topcell] $layer_prboundary

# BBOX remainding geometry and shift.
set bbox_old [$lay bbox [$lay topcell]]
set x_shift 34560
set y_shift 37800

$lay modify origin [$lay topcell] $x_shift $y_shift

# Bring in base fill and adjust blockages.
set top_base_fill [$lay1 topcell] 

foreach layer $layer_base_bfill {
  $lay1 delete polygons [$lay1 topcell] $layer
}

$lay1 modify origin [$lay1 topcell] $x_shift $y_shift

foreach layer $layer_base_bfill {
  eval $lay1 create polygon [$lay1 topcell] $layer $vertices_qp
}

# Bring in metal fill and adjust blockages.
set top_metal_fill [$lay2 topcell] 

foreach layer $layer_metal_bfill {
  $lay2 delete polygons [$lay2 topcell] $layer
}

$lay2 modify origin [$lay2 topcell] $x_shift $y_shift

foreach layer $layer_metal_bfill {
  eval $lay2 create polygon [$lay2 topcell] $layer $vertices_qp
}

# Important to merge but do not allow CalibreDRV to uniquify layers (bump = 0)
layout merge lay_mt $lay1 $lay 0 -mode rename  
layout merge lay_mfin $lay2 lay_mt 0 -mode rename
lay_mfin expand cell [lay_mt topcell]
lay_mfin cellname [lay_mfin topcell] $name_top_new

# Create a PR bounding box in the shape of quadrant pins.
eval lay_mfin create polygon [lay_mfin topcell] $layer_prboundary $vertices_qp
lay_mfin oasisout $standalone_output_path [lay_mfin topcell]

#---------------------------------------------------------------
# PREPARING PLACED SUBMISSION IN DR
#---------------------------------------------------------------
set x_shift_mod -$x_shift
set y_shift_mod -$y_shift

# Shift down the origin to merge onto DR.
lay_mfin modify origin [lay_mfin topcell] $x_shift_mod $y_shift_mod

# Create a reference to locate it within.
layout create lay_dr $dr_path -dt_expand
layout merge lay_mfin_dr lay_mfin lay_dr 0 -mode rename  
lay_mfin_dr delete cell TOP -deleteChildCells

# Drop a reference and update.
lay_mfin_dr create ref $cell_package $name_top_new 0 0 0 0 1
lay_mfin_dr update
lay_mfin_dr oasisout $combined_output_path $cell_package
