vsim DataPath
view wave

add wave Reset
add wave Clock
add wave IR

add wave IR_output_test

add wave ALU_out_test
add wave PS_out_test
add wave DataD_test
add wave RA_output_test
add wave RB_output_test

add wave RM_output_test
add wave RZ_output_test

force reset 0 0
force clock 0 0, 1 10 -repeat 20
force IR 000000000100001100000000 0, 000000000011010000000000 120, 000000000111010100000100 240, 000000000110011100000000 360, 000000000101011000000000 480

run 600