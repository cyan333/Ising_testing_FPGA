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
    output chip_reset,
    output PCHR, 
    output WE, 
    output SA_EN, 
    output reg WBACK,
    output reg writeORread,
    output DRAM_NormalMode_EN, 
    output reg normalORIsing, 
    output RBL_EN_normal, 
    output RBL_bar_EN_normal,
    output reg REF_CTRL_WL,
    output latch_J,
    output reg start_Ising,
    output reg [2:0] J,
    output [5:0] Y_ADDR,
    output reg [6:0] X_ADDR,
    output apply_E_field, 
    output E_field,
    output reg POSNEG_OR_ALLPOS,
    output reg notLatch_SA_OR_latch_SA,
    output reg RBL_REF_BL_or_offchip,
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
    parameter RESET_BEFORE_LATCH_J_TO_DIG = 5;
    parameter LATCH_J_TO_DIG = 6;
    parameter PRECHARGE = 7;
    parameter REF_GEN = 8;
    parameter START_DO_ISING = 9;
    
    parameter read_maxRow = 2;
    
    parameter [8:0] set_J = 9'b010000001;
    
    //reg
    reg [3:0] currentState, nextState;
    reg [8:0] idle_counter, scan_counter;
    reg [4:0] currentReadRow;
    reg WE_fromMain, PCHR_fromMain, DRAM_EN_fromMain, SA_EN_fromMain, RBL_bar_EN_normal_fromMain;
    reg startScan;
    reg Y_ADDR_fromMain;
    reg read_write_flag;
    reg RSTn;
    reg [2:0] latch_J_counter;
    reg [4:0] start_ising_counter;
    reg latch_J_posedge;
    reg RBL_EN_normal_fromMain;
    
    wire scan_done;
    wire writeORread_toscan;
    wire WE_fromScan, PCHR_fromScan, DRAM_EN_fromScan, SA_EN_fromScan, RBL_EN_normal_fromScan, RBL_bar_EN_normal_fromScan;
    wire Y_ADDR_fromScan;
    wire locked;
    wire clk_25M;
    wire clk_10M;
    wire scan_clk_EN;
    
    clock_scan_sys clk_core_uut( 
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
        POSNEG_OR_ALLPOS = 0;
    end
    
    assign latch_J = latch_J_posedge & sys_clk;
    assign chip_reset = ~fpga_reset & RSTn;
    assign sys_clk = clk_25M;
    assign scanclk_out = clk_10M & scan_clk_EN;
    assign writeORread_toscan = writeORread;
    assign update_clk = clk_10M & update_clk_EN;

    assign WE = WE_fromScan | WE_fromMain;
    assign PCHR = PCHR_fromScan & PCHR_fromMain;
    assign DRAM_NormalMode_EN = DRAM_EN_fromScan | DRAM_EN_fromMain;
    assign SA_EN = SA_EN_fromScan | SA_EN_fromMain;
    assign Y_ADDR = Y_ADDR_fromScan | Y_ADDR_fromMain;
    
    assign RBL_EN_normal = RBL_EN_normal_fromMain | RBL_EN_normal_fromScan;
    assign RBL_bar_EN_normal = RBL_bar_EN_normal_fromMain | RBL_bar_EN_normal_fromScan;
    
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
    .DRAM_normalMode_EN(DRAM_EN_fromScan),
    .RBL_EN_normal(RBL_EN_normal_fromScan),
    .RBL_bar_EN_normal(RBL_bar_EN_normal_fromScan)
    );
    
    
    always @ (negedge sys_clk or posedge fpga_reset) begin
        if(fpga_reset) currentState <= IDLE;
        else currentState <= nextState;
    end
    
    always @ (currentState or idle_counter or read_write_flag or scan_counter or scan_done or start_ising_counter or latch_J_counter) begin
    case (currentState) 
    IDLE: begin
        if(idle_counter < 20) begin
           nextState = IDLE;
        end
        else begin
//            nextState = SCAN_WRITE;
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
//        if(scan_done == 1'b1) nextState = IDLE;
        if(scan_done == 1'b1) nextState = SCAN_READ;
        else nextState = DISABLE_SCAN_WRITE;
    end
    SCAN_READ: begin
        if(scan_counter < 10) begin
            nextState = SCAN_READ;
        end
        else begin
            nextState = DISABLE_SCAN_READ;
        end
    end
    
    DISABLE_SCAN_READ: begin
        if(scan_done == 1'b1) nextState = IDLE;
        else nextState = DISABLE_SCAN_READ;
    end
    RESET_BEFORE_LATCH_J_TO_DIG: begin
        nextState = LATCH_J_TO_DIG;
    end
    LATCH_J_TO_DIG: begin
        if(latch_J_counter > 3) begin
            nextState = PRECHARGE;
        end
        else begin
            nextState = LATCH_J_TO_DIG;
        end
    end
    PRECHARGE: begin
        nextState = REF_GEN;
    end
    REF_GEN: begin
        nextState = START_DO_ISING;
    end
    START_DO_ISING: begin
        if(start_ising_counter < 10) begin
            nextState = START_DO_ISING;
        end
        else begin
            nextState = IDLE;
        end
    end
    
    endcase
    end
    
    always @ (posedge sys_clk or posedge fpga_reset) begin
    if(fpga_reset) begin
        RSTn <= 1;
        PCHR_fromMain <= 1;
        WE_fromMain <= 0;
        SA_EN_fromMain <= 0;
        WBACK <= 0;
        RBL_EN_normal_fromMain <= 0;
        RBL_bar_EN_normal_fromMain <= 0;
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
        latch_J_posedge <= 0;
        latch_J_counter <= 0;
        idle_counter <= 0;
        start_Ising <= 0;
        RBL_REF_BL_or_offchip <= 1'b1;
        start_ising_counter <= 0;
        J <= 3'b0;
    end
    else begin
        case (currentState) 
        IDLE: begin
            PCHR_fromMain <= 1;
            WE_fromMain <= 0;
            SA_EN_fromMain <= 0;
            WBACK <= 0;
            RBL_EN_normal_fromMain <= 0;
            RBL_bar_EN_normal_fromMain <= 0;
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
            latch_J_posedge <= 0;
            X_ADDR <= 7'b0;
            idle_counter <= idle_counter + 1;
            start_Ising <= 0;
            RBL_REF_BL_or_offchip <= 1'b1;
            start_ising_counter <= 0;
            J <= 3'b0;
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
            RSTn <= 1;
        end
        
        SCAN_READ: begin
            read_write_flag <= 0;
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
        
        RESET_BEFORE_LATCH_J_TO_DIG: begin
            RSTn <= 1;
            
        end
        LATCH_J_TO_DIG: begin
            WE_fromMain <= 0;
            finish_spin_update <= 0;
            normalORIsing <= 1;
            DRAM_EN_fromMain <= 1;
            latch_J_posedge <= 1;
            if(latch_J_counter == 1) begin
                J = set_J[8:6];
            end
            else if(latch_J_counter == 2) begin
                J = set_J[5:3];
            end
            else if(latch_J_counter == 3) begin
                J = set_J[2:0];
            end
            
            Y_ADDR_fromMain <= 6'b1;
            X_ADDR <= 7'b1;
            start_Ising <= 0;
            latch_J_counter <= latch_J_counter + 1'b1;
        end
        PRECHARGE: begin
            latch_J_posedge <= 0;
            PCHR_fromMain <= 0;
            WE_fromMain <= 0;
            WBACK <= 0;
            DRAM_EN_fromMain <= 0;
            SA_EN_fromMain <= 0;
        end
        REF_GEN: begin
            PCHR_fromMain <= 1;
//            REF_CTRL_WL <= 1;
        end
        START_DO_ISING: begin
            start_Ising <= 1;
            
            start_ising_counter <= start_ising_counter + 1'b1;
        end
        endcase
    end
    end
    
    
    
    
    
    
endmodule
