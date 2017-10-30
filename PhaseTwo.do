vsim DataPath
view wave

add wave Reset
add wave Clock
add wave IR

add wave ALU_out
add wave N
add wave C
add wave Z
add wave V

add wave DataD
add wave RA_output
add wave RB_output
add wave Immediate_output
add wave RM_output
add wave RZ_output
 

force reset 0 0
force clock 0 0, 1 10 -repeat 20
force IR 000000000100000000010010 0



run 100