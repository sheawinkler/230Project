vsim controlUnit
view wave

add wave opCode
add wave Cond
add wave opx
add wave clock
add wave reset
add wave mfc


add wave alu_op
add wave rf_write
add wave b_inv
add wave ir_enable
add wave pc_enable

force clock 0 0, 1 10 -repeat 20
force reset 0 0
force mfc 1 0
force Cond 1111

force opCode 0000 0
force opx 111 0, 110 100, 101 200, 100 300, 011 400

run 500