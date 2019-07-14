onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -radix binary /tb_sanity_test_core/dut/core_0/clk_i 
add wave -radix hexadecimal /tb_sanity_test_core/dut/core_0/instr_req_o 
add wave -radix hexadecimal /tb_sanity_test_core/dut/core_0/instr_addr_o 
add wave -radix hexadecimal /tb_sanity_test_core/dut/core_0/instr_rdata_i 
add wave -radix hexadecimal /tb_sanity_test_core/dut/core_0/data_req_o 
add wave -radix hexadecimal /tb_sanity_test_core/dut/core_0/data_addr_o 
add wave -radix unsigned /tb_sanity_test_core/dut/core_0/data_wdata_o 
add wave -radix hexadecimal /tb_sanity_test_core/dut/core_0/data_rdata_i 
add wave -radix unsigned /tb_sanity_test_core/dut/core_0/alu_operand_a_ex 
add wave -radix unsigned /tb_sanity_test_core/dut/core_0/alu_operand_b_ex 
add wave -radix unsigned /tb_sanity_test_core/dut/core_0/alu_adder_result_ex
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {175 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 272
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {80 ps} {312 ps}
run 165ns
