onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_icache_tb/i_cache/ctrl/state
add wave -noupdate /cpu_icache_tb/arbiter/state
add wave -noupdate /cpu_icache_tb/i_cache/datapath/load_data
add wave -noupdate /cpu_icache_tb/i_cache/datapath/load_tag
add wave -noupdate /cpu_icache_tb/i_cache/datapath/load_lru
add wave -noupdate /cpu_icache_tb/i_cache/datapath/set_valid
add wave -noupdate /cpu_icache_tb/i_cache/datapath/hit0
add wave -noupdate /cpu_icache_tb/i_cache/datapath/hit1
add wave -noupdate /cpu_icache_tb/i_cache/datapath/valid0
add wave -noupdate /cpu_icache_tb/i_cache/datapath/valid1
add wave -noupdate /cpu_icache_tb/i_cache/datapath/tag_out0
add wave -noupdate /cpu_icache_tb/i_cache/datapath/tag_out1
add wave -noupdate /cpu_icache_tb/i_cache/datapath/tag_in
add wave -noupdate /cpu_icache_tb/arbiter/L2/resp
add wave -noupdate /cpu_icache_tb/arbiter/L2/rdata
add wave -noupdate /cpu_icache_tb/physical_memory/rdata
add wave -noupdate /cpu_icache_tb/dut/pc/data
add wave -noupdate /cpu_icache_tb/dut/stall
add wave -noupdate /cpu_icache_tb/dut/I/resp
add wave -noupdate /cpu_icache_tb/dut/I/read
add wave -noupdate /cpu_icache_tb/dut/I/rdata
add wave -noupdate /cpu_icache_tb/dut/I/addr
add wave -noupdate /cpu_icache_tb/dut/D/read
add wave -noupdate /cpu_icache_tb/dut/D/write
add wave -noupdate /cpu_icache_tb/dut/D/wmask
add wave -noupdate /cpu_icache_tb/dut/D/addr
add wave -noupdate /cpu_icache_tb/dut/D/wdata
add wave -noupdate /cpu_icache_tb/dut/D/resp
add wave -noupdate /cpu_icache_tb/dut/D/rdata
add wave -noupdate /cpu_icache_tb/i_cache/datapath/index
add wave -noupdate /cpu_icache_tb/i_cache/datapath/lru_way
add wave -noupdate /cpu_icache_tb/i_cache/datapath/lru/data
add wave -noupdate /cpu_icache_tb/i_cache/datapath/way_select
add wave -noupdate /cpu_icache_tb/i_cache/datapath/way_en0
add wave -noupdate /cpu_icache_tb/i_cache/datapath/way_en1
add wave -noupdate {/cpu_icache_tb/i_cache/datapath/tag[1]/data}
add wave -noupdate -expand {/cpu_icache_tb/i_cache/datapath/tag[0]/data}
add wave -noupdate {/cpu_icache_tb/i_cache/datapath/valid[1]/data}
add wave -noupdate {/cpu_icache_tb/i_cache/datapath/valid[0]/data}
add wave -noupdate -expand {/cpu_icache_tb/i_cache/datapath/data[1]/data}
add wave -noupdate -expand {/cpu_icache_tb/i_cache/datapath/data[0]/data}
add wave -noupdate -expand /cpu_icache_tb/dut/regfile/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1163097 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 303
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
WaveRestoreZoom {1093513 ps} {1189815 ps}
