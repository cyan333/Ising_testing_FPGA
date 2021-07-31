set_property IOSTANDARD LVDS [get_ports sys_clk_p]
set_property IOSTANDARD LVDS [get_ports sys_clk_n]

set_property IOSTANDARD LVCMOS18 [get_ports {fpga_reset}]
set_property IOSTANDARD LVCMOS18 [get_ports {sys_clk}]

set_property IOSTANDARD LVCMOS18 [get_ports {PCHR}]
set_property IOSTANDARD LVCMOS18 [get_ports {SA_EN}]
set_property IOSTANDARD LVCMOS18 [get_ports {WBL_test[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {WBL_test[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {WBL_test[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {RBL_EN}]
set_property IOSTANDARD LVCMOS18 [get_ports {RWL[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {RWL[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {RWL[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {RWL[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {RWL[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {RWL[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {REF_CTRL_WL}]

#######PACKAGE PIN########
#Don't change package pin for clock
set_property PACKAGE_PIN E19 [get_ports sys_clk_p]
set_property PACKAGE_PIN E18 [get_ports sys_clk_n]

#botton
set_property PACKAGE_PIN AV39 [get_ports {fpga_reset}]

set_property PACKAGE_PIN K39 [get_ports {sys_clk}]

set_property PACKAGE_PIN K39 [get_ports {PCHR}]
set_property PACKAGE_PIN K39 [get_ports {SA_EN}]
set_property PACKAGE_PIN K39 [get_ports {WBL_test[0]}]
set_property PACKAGE_PIN K39 [get_ports {WBL_test[1]}]
set_property PACKAGE_PIN K39 [get_ports {WBL_test[2]}]
set_property PACKAGE_PIN K39 [get_ports {RBL_EN}]
set_property PACKAGE_PIN K39 [get_ports {RWL[0]}]
set_property PACKAGE_PIN K39 [get_ports {RWL[1]}]
set_property PACKAGE_PIN K39 [get_ports {RWL[2]}]
set_property PACKAGE_PIN K39 [get_ports {RWL[3]}]
set_property PACKAGE_PIN K39 [get_ports {RWL[4]}]
set_property PACKAGE_PIN K39 [get_ports {RWL[5]}]
set_property PACKAGE_PIN K39 [get_ports {REF_CTRL_WL}]











