`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/27/2021 10:04:05 PM
// Design Name: 
// Module Name: testcase1_teststructure
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


module testcase1_teststructure(
    input sys_clk_p,
    input sys_clk_n,
    input fpga_reset,
    
    output sys_clk

    );
    
    //wire
    wire locked;
    wire clk_25M;
    
    clk_core clk_core_uut(
    .clk_in1_p(sys_clk_p), 
    .clk_in1_n(sys_clk_n), 
    .reset(fpga_reset), 
    .CLK_25M(clk_25M), 
    .locked(locked)
    );
    
    assign sys_clk = clk_25M;
    
    
    
    
    
    
    
endmodule
