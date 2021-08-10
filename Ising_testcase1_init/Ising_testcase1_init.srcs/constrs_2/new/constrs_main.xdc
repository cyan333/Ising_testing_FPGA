set_property IOSTANDARD LVDS [get_ports sys_clk_p]
set_property IOSTANDARD LVDS [get_ports sys_clk_n]

set_property IOSTANDARD LVCMOS18 [get_ports {fpga_reset}]
set_property IOSTANDARD LVCMOS18 [get_ports {sys_clk}]
set_property IOSTANDARD LVCMOS18 [get_ports {chip_reset}]

set_property IOSTANDARD LVCMOS18 [get_ports {PCHR}]
set_property IOSTANDARD LVCMOS18 [get_ports {WE}]
set_property IOSTANDARD LVCMOS18 [get_ports {SA_EN}]
set_property IOSTANDARD LVCMOS18 [get_ports {WBACK}]
set_property IOSTANDARD LVCMOS18 [get_ports {writeORread}]
set_property IOSTANDARD LVCMOS18 [get_ports {DRAM_NormalMode_EN}]
set_property IOSTANDARD LVCMOS18 [get_ports {normalORIsing}]
set_property IOSTANDARD LVCMOS18 [get_ports {RBL_EN_normal}]
set_property IOSTANDARD LVCMOS18 [get_ports {RBL_bar_EN_normal}]
set_property IOSTANDARD LVCMOS18 [get_ports {REF_CTRL_WL}]
set_property IOSTANDARD LVCMOS18 [get_ports {latch_J}]
set_property IOSTANDARD LVCMOS18 [get_ports {start_Ising}]


set_property IOSTANDARD LVCMOS18 [get_ports {J[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {J[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {J[2]}]

set_property IOSTANDARD LVCMOS18 [get_ports {Y_ADDR[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {Y_ADDR[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {Y_ADDR[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {Y_ADDR[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {Y_ADDR[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {Y_ADDR[5]}]

set_property IOSTANDARD LVCMOS18 [get_ports {X_ADDR[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {X_ADDR[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {X_ADDR[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {X_ADDR[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {X_ADDR[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {X_ADDR[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {X_ADDR[6]}]

set_property IOSTANDARD LVCMOS18 [get_ports {apply_E_field}]
set_property IOSTANDARD LVCMOS18 [get_ports {E_field}]
set_property IOSTANDARD LVCMOS18 [get_ports {POSNEG_OR_ALLPOS}]
set_property IOSTANDARD LVCMOS18 [get_ports {notLatch_SA_OR_latch_SA}]
set_property IOSTANDARD LVCMOS18 [get_ports {RBL_REF_BL_or_offchip}]

set_property IOSTANDARD LVCMOS18 [get_ports {finish_spin_update}]

set_property IOSTANDARD LVCMOS18 [get_ports {spin_update_EN}]
set_property IOSTANDARD LVCMOS18 [get_ports {scanclk_out}]
set_property IOSTANDARD LVCMOS18 [get_ports {se}]
set_property IOSTANDARD LVCMOS18 [get_ports {update_clk}]
set_property IOSTANDARD LVCMOS18 [get_ports {scanin}]


#######PACKAGE PIN########
#Don't change package pin for clock
set_property PACKAGE_PIN E19 [get_ports sys_clk_p]
set_property PACKAGE_PIN E18 [get_ports sys_clk_n]

#botton
set_property PACKAGE_PIN AV39 [get_ports {fpga_reset}]

set_property PACKAGE_PIN K39 [get_ports {sys_clk}]
set_property PACKAGE_PIN H28 [get_ports {chip_reset}]

set_property PACKAGE_PIN D33 [get_ports {PCHR}]
set_property PACKAGE_PIN M42 [get_ports {WE}]
set_property PACKAGE_PIN H36 [get_ports {SA_EN}]
set_property PACKAGE_PIN G32 [get_ports {WBACK}]
set_property PACKAGE_PIN G33 [get_ports {writeORread}]
set_property PACKAGE_PIN H33 [get_ports {DRAM_NormalMode_EN}]
set_property PACKAGE_PIN M22 [get_ports {normalORIsing}]
set_property PACKAGE_PIN M41 [get_ports {RBL_EN_normal}]
set_property PACKAGE_PIN J36 [get_ports {RBL_bar_EN_normal}]
set_property PACKAGE_PIN J22 [get_ports {REF_CTRL_WL}]
set_property PACKAGE_PIN H29 [get_ports {latch_J}]
set_property PACKAGE_PIN F34 [get_ports {start_Ising}]


set_property PACKAGE_PIN H41 [get_ports {J[0]}]
set_property PACKAGE_PIN H40 [get_ports {J[1]}]
set_property PACKAGE_PIN L42 [get_ports {J[2]}]

set_property PACKAGE_PIN M37 [get_ports {Y_ADDR[0]}]
set_property PACKAGE_PIN G42 [get_ports {Y_ADDR[1]}]
set_property PACKAGE_PIN G41 [get_ports {Y_ADDR[2]}]
set_property PACKAGE_PIN J42 [get_ports {Y_ADDR[3]}]
set_property PACKAGE_PIN K42 [get_ports {Y_ADDR[4]}]
set_property PACKAGE_PIN L41 [get_ports {Y_ADDR[5]}]

set_property PACKAGE_PIN J28 [get_ports {X_ADDR[0]}]
set_property PACKAGE_PIN G28 [get_ports {X_ADDR[1]}]
set_property PACKAGE_PIN G29 [get_ports {X_ADDR[2]}]
set_property PACKAGE_PIN H24 [get_ports {X_ADDR[3]}]
set_property PACKAGE_PIN P42 [get_ports {X_ADDR[4]}]
set_property PACKAGE_PIN R42 [get_ports {X_ADDR[5]}]
set_property PACKAGE_PIN M38 [get_ports {X_ADDR[6]}]

set_property PACKAGE_PIN C39 [get_ports {apply_E_field}]
set_property PACKAGE_PIN C38 [get_ports {E_field}]
set_property PACKAGE_PIN G37 [get_ports {POSNEG_OR_ALLPOS}]
set_property PACKAGE_PIN F32 [get_ports {notLatch_SA_OR_latch_SA}]
set_property PACKAGE_PIN F35 [get_ports {RBL_REF_BL_or_offchip}]

set_property PACKAGE_PIN G36 [get_ports {finish_spin_update}]

set_property PACKAGE_PIN K28 [get_ports {spin_update_EN}]
set_property PACKAGE_PIN J40 [get_ports {scanclk_out}]
set_property PACKAGE_PIN E32 [get_ports {se}]
set_property PACKAGE_PIN E33 [get_ports {update_clk}]
set_property PACKAGE_PIN P41 [get_ports {scanin}]


set_property SLEW FAST [get_ports -filter "direction==out"]
set_property DRIVE 16 [get_ports -filter "direction==out"]
set_load 10 [get_ports -filter "direction==out"]

#create_clock -name clock -period 40 -waveform "0 20" 
#set_input_delay -clock [get_clocks clock] 10 [get_ports data_out*]
#set_output_delay -clock [get_clocks clock] 10 [get_ports data_in*]

set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property CFGBVS GND [current_design]
set_property BITSTREAM.CONFIG.BPI_SYNC_MODE Type1 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN div-1 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS FALSE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pulldown [current_design]
set_property CONFIG_MODE BPI16 [current_design]











