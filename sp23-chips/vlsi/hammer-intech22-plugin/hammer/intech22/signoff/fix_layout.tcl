# 
# Deuniquify specified cells from the database OR
# Instantiate and rotate a design (R90)
#
# calibredrv -shell fix_layout.tcl gds_or_oasis_filename <cells_to_deuniquify>
#
# Will only deuniquify cells if list of cells are passed in, otherwise export a rotated database

if {$argc == 0} {
    puts "Usage: calibredrv -shell fix_layout.tcl [filename.gds|filename.oas] [cells_to_deuniquify]"
    exit -1
}

set layout_file [lindex $argv 0]
# Peel off up to two suffixes from the input file name
set layout_rootname [file rootname [file rootname $layout_file]]

# Open the input database
set lay [layout create $layout_file -dt_expand -preservePaths \
	     -preserveTextAttributes -preserveProperties]

# Alternate commands to open the layout in an interactive session:
# set wb [find objects -class cwbWorkBench]
# set lay [$wb cget -_layout]

set top_cell [$lay topcell]

if {$argc > 1} {
    if {[lsearch $argv OAS_ONLY] != -1 || [lsearch $argv GDS_ONLY] != -1} {
        set to_deuniquify [lrange $argv 2 end]
    } else {
        set to_deuniquify [lrange $argv 1 end]
    }
    foreach cell_to_deuniq $to_deuniquify {
        puts "Deuniquifying $cell_to_deuniq ..."
        set wild_cell *${cell_to_deuniq}_*
        set to_delete {}
        # Find cells that contain other cells to replace (20 levels should be enough?)
        set cell_info [$lay iterator ref $top_cell range 0 end -depth 0 19 -filterCell $wild_cell]
        set containing_cells {}
        foreach c $cell_info {
            lappend containing_cells [file tail [lindex $c 1 0]]
        }
        set containing_cells [lsort -unique $containing_cells]
        puts "Containing cells: $containing_cells"
        
        foreach cell $containing_cells {
            set cell_info [$lay iterator ref $cell range 0 end -depth 0 0 -filterCell $wild_cell -arefToSrefs]
            foreach c $cell_info {
        	    # Skip cells that were not uniquified.
                # Should not be true if wildcard successful above.
        	    if {![string compare [lindex $c 0 0] $cell_to_deuniq]} continue

        	    # Create a replacement reference to the original cell:
        	    puts [list $lay create ref $cell $cell_to_deuniq {*}[lrange [lindex $c 0] 1 5]]
        	    $lay create ref $cell $cell_to_deuniq {*}[lrange [lindex $c 0] 1 5]

                # Mark for deletion
                lappend to_delete [lindex $c 0 0]
            }
        }
        # Finally delete the uniquified cell from the database
        foreach cell [lsort -unique $to_delete] {
            puts [list $lay delete cell $cell]
            $lay delete cell $cell
        }
    }

    # Save the deuniquified design:
    # Overwrites original GDS
    if {[lsearch $argv OAS_ONLY] != -1} {
        $lay oasisout ${layout_rootname}.oas ${top_cell}
    } elseif {[lsearch $argv GDS_ONLY] != -1} {
        $lay gdsout ${layout_rootname}.gds ${top_cell}
    } else {
        $lay gdsout ${layout_rootname}.gds ${top_cell}
        $lay oasisout ${layout_rootname}.oas ${top_cell}
    }

} else {
    # Create a cell with a rotated reference to the top cell:
    set top_r90 ${top_cell}_R90
    $lay create cell $top_r90
    $lay create ref $top_r90 $top_cell 0 0 0 270.0 1.0
    
    set rot_bbox [$lay bbox $top_r90]
    $lay create polygon $top_r90 50 {*}$rot_bbox
    $lay create polygon $top_r90 50.99 {*}$rot_bbox
    
    $lay oasisout ${layout_rootname}_R90.oas $top_r90
    # $lay gdsout ${layout_rootname}_R90.gds $top_r90
}
