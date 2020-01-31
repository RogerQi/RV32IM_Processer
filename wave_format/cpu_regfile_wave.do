onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/timeout
add wave -noupdate /cpu_tb/itf/clk
add wave -noupdate /cpu_tb/dut/stall_i_cache
add wave -noupdate /cpu_tb/dut/stall_d_cache
add wave -noupdate /cpu_tb/dut/I/resp
add wave -noupdate /cpu_tb/dut/D/resp
add wave -noupdate /cpu_tb/cpu_imem/read
add wave -noupdate /cpu_tb/cpu_dmem/read
add wave -noupdate /cpu_tb/cpu_dmem/write
add wave -noupdate /cpu_tb/cpu_dmem/wmask
add wave -noupdate /cpu_tb/cpu_imem/rdata
add wave -noupdate /cpu_tb/cpu_imem/addr
add wave -noupdate /cpu_tb/cpu_dmem/addr
add wave -noupdate /cpu_tb/dut/alu_out
add wave -noupdate /cpu_tb/dut/MEM_in.alu_out
add wave -noupdate /cpu_tb/cpu_dmem/wdata
add wave -noupdate /cpu_tb/cpu_dmem/rdata
add wave -noupdate /cpu_tb/dut/pcmux_sel
add wave -noupdate /cpu_tb/dut/pc/data
add wave -noupdate -expand /cpu_tb/dut/EX_in
add wave -noupdate /cpu_tb/dut/control_rom/ctrl_word
add wave -noupdate -expand /cpu_tb/dut/regfile/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37108 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 231
configure wave -valuecolwidth 110
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
WaveRestoreZoom {0 ps} {100577 ps}
