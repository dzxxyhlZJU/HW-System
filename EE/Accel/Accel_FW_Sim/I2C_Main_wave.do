onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /I2C_main_tb/I2C_main/clk_I2C
add wave -noupdate /I2C_main_tb/I2C_main/clk_in
add wave -noupdate /I2C_main_tb/I2C_main/configure_en
add wave -noupdate -radix unsigned /I2C_main_tb/I2C_main/next_state
add wave -noupdate -radix unsigned /I2C_main_tb/I2C_main/current_state
add wave -noupdate /I2C_main_tb/I2C_main/reset_n
add wave -noupdate /I2C_main_tb/I2C_main/DelayCount/DelayEnable
add wave -noupdate /I2C_main_tb/I2C_main/DelayCount/DelayDone
add wave -noupdate /I2C_main_tb/I2C_main/DelayCount/DelayClk
add wave -noupdate -radix unsigned /I2C_main_tb/I2C_main/DelayCount/DelayTime
add wave -noupdate /I2C_main_tb/I2C_main/Accel_sda_out
add wave -noupdate /I2C_main_tb/I2C_main/Accel_scl
add wave -noupdate -radix hexadecimal /I2C_main_tb/I2C_main/I2C_wdata
add wave -noupdate -radix hexadecimal /I2C_main_tb/I2C_main/I2C_rdata
add wave -noupdate -radix unsigned /I2C_main_tb/I2C_main/I2C_Bus/I2C_NM
add wave -noupdate -radix unsigned /I2C_main_tb/I2C_main/I2C_Bus/cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {283433 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 202
configure wave -valuecolwidth 82
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
configure wave -timelineunits ps
update
WaveRestoreZoom {181795 ps} {786568 ps}
