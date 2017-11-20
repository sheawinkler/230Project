vsim DataPath
view wave


add wave Clock

add wave PS_out_test

add wave IAG_test
add wave Data_out_test
add wave Mem_address_test
add wave IR_output_test
add wave RA_output_test
add wave RB_output_test
add wave ALU_out_test
add wave RZ_output_test
add wave RM_output_test
add wave DataD_test

add wave KEY
add wave SW

add wave LEDG
add wave HEX0


force clock 0 0, 1 1000 -repeat 2000
force KEY 0000 0, 0100 2000 -repeat 4000
force SW 0000000000 0, 0000001000 4000 -repeat 8000

run 150000