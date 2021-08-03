`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2021 02:55:42 PM
// Design Name: 
// Module Name: testcase2_main_SIM
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


module testcase2_main_SIM( );

    reg sys_clk_p;
    reg sys_clk_n;
    reg fpga_reset;
    
    wire sys_clk;
    
    wire PCHR; 
    wire WE; 
    wire SA_EN; 
    wire WBACK;
    wire writeORread;
    wire DRAM_NormalMode_EN; 
    wire normalORIsing; 
    wire RBL_EN_normal; 
    wire RBL_bar_EN_normal;
    wire REF_CTRL_WL;
    wire latch_J;
    wire [2:0] J;
    wire [5:0] Y_ADDR;
    wire [6:0] X_ADDR;
    wire apply_E_field; 
    wire E_field;
    wire POSNEG_OR_ALLPOS;
    wire notLatch_SA_OR_latch_SA;
    
    wire finish_spin_update;
    wire spin_update_EN;
    
    //Scan chain
    wire scanclk_out;
    wire se;
    wire update_clk;
    wire scanin;
    
    testcase2_main tb2_uut(
    .sys_clk_p(sys_clk_p),
    .sys_clk_n(sys_clk_n),
    .fpga_reset(fpga_reset),
    .sys_clk(sys_clk),
    .PCHR(PCHR), 
    .WE(WE),  
    .SA_EN(SA_EN),  
    .WBACK(WBACK), 
    .writeORread(writeORread), 
    .DRAM_NormalMode_EN(DRAM_NormalMode_EN), 
    .normalORIsing(normalORIsing),   
    .RBL_EN_normal(RBL_EN_normal),  
    .RBL_bar_EN_normal(RBL_bar_EN_normal),  
    .REF_CTRL_WL(REF_CTRL_WL),  
    .latch_J(latch_J),  
    .J(J),  
    .Y_ADDR(Y_ADDR),  
    .X_ADDR(X_ADDR),  
    .apply_E_field(apply_E_field),   
    .E_field(E_field),  
    .POSNEG_OR_ALLPOS(POSNEG_OR_ALLPOS),  
    .notLatch_SA_OR_latch_SA(notLatch_SA_OR_latch_SA),  
    .finish_spin_update(finish_spin_update),
    .spin_update_EN(spin_update_EN),
    .scanclk_out(scanclk_out),
    .se(se),
    .update_clk(update_clk),
    .scanin(scanin)
    );
    
    initial sys_clk_p = 1'b1;
    always #(2.5) sys_clk_p = ~sys_clk_p;
    
    initial sys_clk_n = 1'b0;
    always #(2.5) sys_clk_n = ~sys_clk_n;
    
initial begin
fpga_reset = 1'b0;
#300;
fpga_reset = 1'b1;
#20;
fpga_reset = 1'b0;
end

endmodule
