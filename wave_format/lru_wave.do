onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lru_tb/clk
add wave -noupdate /lru_tb/lru_in
add wave -noupdate /lru_tb/index_in
add wave -noupdate /lru_tb/load_lru
add wave -noupdate /lru_tb/lru_out
add wave -noupdate -expand /lru_tb/lru_new/mru_efr
add wave -noupdate /lru_tb/lru_new/mru_in
add wave -noupdate /lru_tb/lru_new/mru_in_efr
add wave -noupdate /lru_tb/lru_new/mru_efr_load
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37500267063 ps} 0}
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
WaveRestoreZoom {0 ps} {134217728 ns}
