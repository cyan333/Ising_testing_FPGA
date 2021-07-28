`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/27/2021 10:28:59 PM
// Design Name: 
// Module Name: testcase1_teststructure_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testcase1_teststructure_tb();
reg sys_clk_p;
reg sys_clk_n;
reg fpga_reset;

wire sys_clk;


testcase1_teststructure tb1_uut(
.sys_clk_p(sys_clk_p),
.sys_clk_n(sys_clk_n),
.fpga_reset(fpga_reset),
.sys_clk(sys_clk)

);


initial sys_clk_p = 1'b1;
always #(2.5) sys_clk_p = ~sys_clk_p;

initial sys_clk_n = 1'b0;
always #(2.5) sys_clk_n = ~sys_clk_n;

initial begin
fpga_reset = 1'b0;
#5;
fpga_reset = 1'b1;

#5;
fpga_reset = 1'b0;

end
endmodule
