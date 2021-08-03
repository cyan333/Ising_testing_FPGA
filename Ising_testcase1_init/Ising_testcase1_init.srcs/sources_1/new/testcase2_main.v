`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2021 08:49:22 PM
// Design Name: 
// Module Name: testcase2_main
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


module testcase2_main(
    input sys_clk_p,
    input sys_clk_n,
    input fpga_reset,
    
    output sys_clk,
    
    output PCHR, 
    output WE, 
    output SA_EN, 
    output reg WBACK,
    output reg writeORread,
    output DRAM_NormalMode_EN, 
    output reg normalORIsing, 
    output reg RBL_EN_normal, 
    output reg RBL_bar_EN_normal,
    output reg REF_CTRL_WL,
    output reg latch_J,
    output reg [2:0] J,
    output [5:0] Y_ADDR,
    output reg [6:0] X_ADDR,
    output apply_E_field, 
    output E_field,
    output reg POSNEG_OR_ALLPOS,
    output reg notLatch_SA_OR_latch_SA,
    
    output reg finish_spin_update,
    output reg spin_update_EN,
    
    //Scan chain
    output scanclk_out,
    output se,
    output update_clk,
    output scanin
    

    );
    
    parameter IDLE = 0;
    parameter SCAN_WRITE = 1;
    parameter DISABLE_SCAN_WRITE = 2;
    parameter SCAN_READ = 3;
    parameter DISABLE_SCAN_READ = 4;
    
    parameter read_maxRow = 2;
    
    
    //reg
    reg [3:0] currentState, nextState;
    reg [8:0] idle_counter, scan_counter;
    reg [4:0] currentReadRow;
    reg WE_fromMain, PCHR_fromMain, DRAM_EN_fromMain, SA_EN_fromMain;
    reg startScan;
    reg Y_ADDR_fromMain;
    reg read_write_flag;

    wire scan_done;
    wire writeORread_toscan;
    wire WE_fromScan, PCHR_fromScan, DRAM_EN_fromScan, SA_EN_fromScan;
    wire Y_ADDR_fromScan;
    wire locked;
    wire clk_25M;
    wire clk_10M;
    wire scan_clk_EN;
    
    sysclk_and_scan_clk clk_core_uut( 
    .clk_in1_p(sys_clk_p), 
    .clk_in1_n(sys_clk_n), 
    .reset(fpga_reset), 
    .CLK_25M(clk_25M), 
    .CLK_10M(clk_10M),
    .locked(locked)
    );
    
    initial begin
        read_write_flag = 1'b0;
        notLatch_SA_OR_latch_SA = 1'b1;
    end
    
    
    assign sys_clk = clk_25M;
    assign scanclk_out = clk_10M & scan_clk_EN;
    assign writeORread_toscan = writeORread;
    assign update_clk = clk_10M & update_clk_EN;

    assign WE = WE_fromScan | WE_fromMain;
    assign PCHR = PCHR_fromScan & PCHR_fromMain;
    assign DRAM_NormalMode_EN = DRAM_EN_fromScan | DRAM_EN_fromMain;
    assign SA_EN = SA_EN_fromScan | SA_EN_fromMain;
    assign Y_ADDR = Y_ADDR_fromScan | Y_ADDR_fromMain;
    
    scan_module scanchain_uut(
    .scan_clk(clk_10M),
    .reset(fpga_reset),
    .startScan(startScan),
    .writeORread(writeORread_toscan),
    .update_clk(update_clk),
    .se(se),
    .scanin(scanin),
    .scan_clk_EN(scan_clk_EN),
    .update_clk_EN(update_clk_EN),
    .all_scan_done(scan_done),
    .ADDR(Y_ADDR_fromScan),
    .WE(WE_fromScan),
    .SA_EN(SA_EN_fromScan),
    .PCHR(PCHR_fromScan),
    .DRAM_normalMode_EN(DRAM_EN_fromScan)
    );
    
    
    always @ (negedge sys_clk or posedge fpga_reset) begin
        if(fpga_reset) currentState <= IDLE;
        else currentState <= nextState;
    end
    
    always @ (currentState or idle_counter or scan_counter or scan_done) begin
    case (currentState) 
    IDLE: begin
        if(idle_counter < 20) begin
           nextState = IDLE;
        end
        else begin
            if(!read_write_flag) begin
                
                nextState = SCAN_WRITE;
            end
            else begin
                
                nextState = SCAN_READ;
            end
        end
    end
    SCAN_WRITE: begin
        if(scan_counter < 10) begin
            nextState = SCAN_WRITE;
        end
        else begin
            nextState = DISABLE_SCAN_WRITE;
        end
        
    end
    DISABLE_SCAN_WRITE: begin
        if(scan_done == 1'b1) nextState = IDLE;
        else nextState = DISABLE_SCAN_WRITE;
    end
    SCAN_READ: begin
        if(scan_counter < 10) begin
            nextState = SCAN_READ;
        end
        else begin
            nextState = DISABLE_SCAN_WRITE;
        end
        
    end
    DISABLE_SCAN_READ: begin
        if(scan_done == 1'b1) nextState = IDLE;
        else nextState = DISABLE_SCAN_READ;
    end
    endcase
    end
    
    always @ (posedge sys_clk or posedge fpga_reset) begin
    if(fpga_reset) begin
        PCHR_fromMain <= 1;
        WE_fromMain <= 0;
        SA_EN_fromMain <= 0;
        WBACK <= 0;
        RBL_EN_normal <= 0;
        RBL_bar_EN_normal <= 0;
        REF_CTRL_WL <= 0;
        writeORread <= 0;
        DRAM_EN_fromMain <= 0;
        normalORIsing <= 0;
        Y_ADDR_fromMain <= 6'b0;
        finish_spin_update <= 0;
        spin_update_EN <= 0;
        startScan <= 1'b0;
        scan_counter <= 0;
        currentReadRow <= 5'd0;
        latch_J <= 0;
        
        idle_counter <= 0;
    end
    else begin
        case (currentState) 
        IDLE: begin
            PCHR_fromMain <= 1;
            WE_fromMain <= 0;
            SA_EN_fromMain <= 0;
            WBACK <= 0;
            RBL_EN_normal <= 0;
            RBL_bar_EN_normal <= 0;
            REF_CTRL_WL <= 0;
            writeORread <= 0;
            DRAM_EN_fromMain <= 0;
            normalORIsing <= 0;
            Y_ADDR_fromMain <= 6'b0;
            finish_spin_update <= 0;
            spin_update_EN <= 0;
            startScan <= 1'b0;
            scan_counter <= 0;
            currentReadRow <= 5'd0;
            latch_J <= 0;
            
            idle_counter <= idle_counter + 1;
            
        end
        
        SCAN_WRITE: begin
            read_write_flag = 1;
            idle_counter <= 0;
            writeORread <= 0;
            startScan <= 1'b1;
            scan_counter <= scan_counter + 1;
        end
        
        DISABLE_SCAN_WRITE: begin
            startScan <= 1'b0;
            scan_counter <= 0;
    
        end
        
        SCAN_READ: begin
            read_write_flag = 0;
            idle_counter <= 0;
            writeORread <= 1;
            normalORIsing <= 0;
            startScan <= 1;
            scan_counter <= scan_counter + 1;
        end
        
        DISABLE_SCAN_READ: begin
            startScan <= 1'b0;
            scan_counter <= 0;
        end
    
        endcase
    end
    end
    
    
    
    
    
    
endmodule
