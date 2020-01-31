onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /full_tb/timeout
add wave -noupdate /full_tb/clk
add wave -noupdate -expand -group D_Cache /full_tb/dut/cpu_dcache/read
add wave -noupdate -expand -group D_Cache /full_tb/dut/cpu_dcache/write
add wave -noupdate -expand -group D_Cache /full_tb/dut/cpu_dcache/resp
add wave -noupdate -expand -group D_Cache /full_tb/dut/d_cache/datapath/load_lru
add wave -noupdate -expand -group D_Cache /full_tb/dut/d_cache/datapath/hit_out
add wave -noupdate -expand -group D_Cache /full_tb/dut/d_cache/datapath/dirty_out
add wave -noupdate -expand -group D_Cache /full_tb/dut/d_cache/datapath/way_lru
add wave -noupdate -expand -group D_Cache /full_tb/dut/d_cache/datapath/way_hit
add wave -noupdate -expand -group D_Cache /full_tb/dut/d_cache/datapath/hit
add wave -noupdate -expand -group D_Cache /full_tb/dut/d_cache/datapath/way_en
add wave -noupdate -expand -group D_Cache /full_tb/dut/d_cache/datapath/index
add wave -noupdate -expand -group I_Cache /full_tb/dut/cpu_icache/read
add wave -noupdate -expand -group I_Cache /full_tb/dut/cpu_icache/resp
add wave -noupdate -expand -group I_Cache /full_tb/dut/i_cache/load_lru
add wave -noupdate -expand -group I_Cache /full_tb/dut/i_cache/datapath/hit_out
add wave -noupdate -expand -group I_Cache /full_tb/dut/i_cache/datapath/way_lru
add wave -noupdate -expand -group I_Cache /full_tb/dut/i_cache/datapath/way_hit
add wave -noupdate -expand -group I_Cache /full_tb/dut/i_cache/datapath/hit
add wave -noupdate -expand -group I_Cache /full_tb/dut/i_cache/datapath/way_en
add wave -noupdate -expand -group I_Cache /full_tb/dut/i_cache/datapath/index
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {209586220 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {209404689 ps} {209916689 ps}
