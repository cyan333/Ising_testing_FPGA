`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2021 08:49:22 PM
// Design Name: 
// Module Name: testcase3_annealing
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


module testcase3_annealing(
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
    output scanin,
    output reg charge_share,
    output reg latched_SA_OUT

    );
    
    parameter IDLE = 0;
    parameter SCAN_WRITE = 1;
    parameter DISABLE_SCAN_WRITE = 2;
    parameter SCAN_READ = 3;
    parameter DISABLE_SCAN_READ = 4;
    
    parameter PRECHARGE_BEFORE_READ = 5;
    parameter FIRE_RWL = 6;
    parameter FIRE_SA_for_READ = 7;
    
    parameter ANNEALING_WBACK = 8;
    parameter RESET_AFTER_ANNEALING = 9;
    
    
    parameter read_maxRow = 2;
    
    parameter [8:0] set_J = 9'b111101111;
    
    //reg
    reg latch_J_posedge;
    reg [3:0] currentState, nextState;
    reg [8:0] idle_counter, scan_counter;
    reg [4:0] currentReadRow;
    reg WE_fromMain, PCHR_fromMain, DRAM_EN_fromMain, SA_EN_fromMain, RBL_bar_EN_normal_fromMain;
    reg startScan;
    reg [5:0] Y_ADDR_fromMain;
    reg read_write_flag;
    reg RSTn;
    reg [3:0] latch_J_counter;
    reg [6:0] start_ising_counter;
    reg finish_annealing;
    reg RBL_EN_normal_fromMain;
    
    wire scan_done;
    wire writeORread_toscan;
    wire WE_fromScan, PCHR_fromScan, DRAM_EN_fromScan, SA_EN_fromScan, RBL_EN_normal_fromScan, RBL_bar_EN_normal_fromScan;
    wire [5:0] Y_ADDR_fromScan;
    wire locked;
    wire clk_25M;
    wire clk_10M;
    wire clk_40M;
    wire scan_clk_EN;
    wire last_row, chip_reset_fromScan;
    
    clock_scan_sys clk_core_uut( 
    .clk_in1_p(sys_clk_p), 
    .clk_in1_n(sys_clk_n), 
    .reset(fpga_reset), 
    .CLK_25M(clk_25M), 
    .CLK_10M(clk_10M),
    .CLK_40M(clk_40M),
    .locked(locked)
    );
    
    initial begin
        read_write_flag = 1'b0;
        notLatch_SA_OR_latch_SA = 1'b1;
        POSNEG_OR_ALLPOS = 0;
    end
    
    assign latch_J = latch_J_posedge & sys_clk;
    assign chip_reset = (~fpga_reset & RSTn) & chip_reset_fromScan;
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
    
    scan_annealing scanchain_uut(
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
    .RBL_bar_EN_normal(RBL_bar_EN_normal_fromScan),
    .last_row(last_row),
    .chip_reset_fromScan(chip_reset_fromScan)
    );
    
    
    always @ (negedge sys_clk or posedge fpga_reset) begin
        if(fpga_reset) currentState <= IDLE;
        else currentState <= nextState;
    end
    
    always @ (currentState or idle_counter or finish_annealing or read_write_flag or scan_counter or scan_done or start_ising_counter or latch_J_counter or last_row) begin
    case (currentState) 
    IDLE: begin
        if(idle_counter < 20) begin
           nextState = IDLE;
        end
        else begin
            nextState = SCAN_WRITE;
//            if(!read_write_flag) begin
//                nextState = SCAN_WRITE;
//            end
//            else begin
//                nextState = SCAN_READ;
//            end
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
        if(last_row == 1'b1) nextState = SCAN_READ;
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
        if(last_row == 1'b1 && finish_annealing == 1'b0) nextState = PRECHARGE_BEFORE_READ;
        else if (finish_annealing == 1'b1) nextState = IDLE;
        else nextState = DISABLE_SCAN_READ;
    end
    PRECHARGE_BEFORE_READ: begin
        nextState = FIRE_RWL;
    end
    FIRE_RWL: begin
        nextState = FIRE_SA_for_READ;
    end
    FIRE_SA_for_READ: begin
        nextState = ANNEALING_WBACK;
    end
    ANNEALING_WBACK: begin
        nextState = RESET_AFTER_ANNEALING;
    end
    RESET_AFTER_ANNEALING: begin
        nextState = SCAN_READ;
    end
    endcase
    end
    
    always @ (negedge sys_clk or posedge fpga_reset) begin
    if(fpga_reset) begin
        latched_SA_OUT <= 0;
    end
    else begin
    case (currentState) 
    IDLE: begin
        latched_SA_OUT <= 0;
    end

    
    endcase
    end
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
        charge_share <= 0;
        finish_annealing <= 0;
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
            latch_J_counter <= 0;
            charge_share <= 0;
            finish_annealing <= 0;
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
        PRECHARGE_BEFORE_READ: begin
//            RSTn <= 0;
            PCHR_fromMain <= 0;
            WE_fromMain <= 0;
            SA_EN_fromMain <= 0;
            WBACK <= 0;
            RBL_EN_normal_fromMain <= 1;
            RBL_bar_EN_normal_fromMain <= 0;
            
            
            DRAM_EN_fromMain <= 0;
            normalORIsing <= 0;
            Y_ADDR_fromMain <= 6'd3;
           
        end
        FIRE_RWL: begin
            PCHR_fromMain <= 1;
            DRAM_EN_fromMain <= 1;
        end
        FIRE_SA_for_READ: begin
            SA_EN_fromMain <= 1;
            WE_fromMain <= 1;
            DRAM_EN_fromMain <= 0;
            
        end
        ANNEALING_WBACK: begin
            DRAM_EN_fromMain <= 1;
            writeORread <= 0; //read
            
        end
        RESET_AFTER_ANNEALING: begin
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
            latch_J_counter <= 0;
            charge_share <= 0;
            finish_annealing <= 1;
        
        end
        
        
        endcase
    end
    end
    
    
    
    
    
    
endmodule
