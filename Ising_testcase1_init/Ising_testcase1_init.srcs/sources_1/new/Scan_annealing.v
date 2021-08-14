`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2021 09:32:38 PM
// Design Name: 
// Module Name: scan_annealing
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


module scan_annealing(
    input scan_clk,
    input reset,
    input startScan,
    
    //scan parameter
//    input [9:0] maxCol,
//    input [5:0] maxRow,
    
    
    //config
    input writeORread,
    //output
    output update_clk,
    output reg se,
    output reg scanin,
    
    output reg scan_clk_EN,
    output reg update_clk_EN,
    output reg all_scan_done,
    
    output [5:0] ADDR,
    output reg WE, SA_EN, PCHR, DRAM_normalMode_EN, RBL_EN_normal, RBL_bar_EN_normal,
    output reg last_row,
    output reg chip_reset_fromScan

    );
    
    parameter IDLE = 4'd0;
    parameter WRITE = 4'd1;
    parameter UPDATE = 4'd2;
    parameter UPDATE_VALUE = 4'd3;
//    parameter RESET = 3'd4;
//    parameter READ = 3'd5;
//    parameter SCANOUT = 3'd6;
    parameter PRECHARGE_BEFORE_READ = 4'd4;
    parameter FIRE_RWL = 4'd5;
    parameter FIRE_SA_for_READ = 4'd6;
    parameter SCANOUT = 4'd7;
    
    parameter scan_length = 207;
    parameter write_maxCol = scan_length;
    parameter write_maxRow = 4'd1;
    parameter read_maxRow = 4'd1;
    parameter read_maxCol = 4;

    reg [2:0] currentState, nextState; 
    
    reg scan_done; //indicate: scan has finished for one row.
    reg [9:0] this_scancol; //track: which scan bit it is currently scanning
    reg [5:0] currentAccessRow;
    reg [1:0] update_count;
    reg didUpdateRowValue;
    reg update_done;
    
    // Memeory input data
    reg [207-1:0] inputData[write_maxRow-1:0];
    
    reg [scan_length-1:0] totalScanData[write_maxRow-1:0];
    reg [scan_length-1:0] thisRowValue;
    reg [4:0] ONE_BANK_HEIGHT;
    reg [3:0] annealing_data;

//    reg [3:0] write_maxCol, write_maxRow, read_maxRow, read_maxCol;
    reg [3:0] read_timer;
    
    assign ADDR = currentAccessRow;
    
    initial begin
        inputData[0] = 101'b111;
        inputData[1] = 101'b111;
        inputData[2] = 101'b111;
        
        inputData[3] = 101'b0;
        inputData[4] = 101'b0;
        inputData[5] = 101'b0;
        annealing_data = 4'b0110;

    end
    
    always @ (negedge scan_clk) begin
    if (last_row) begin
        all_scan_done <= 1;
    end
    else begin
        all_scan_done <= 0;
    end        
    end
    
    always @ (posedge scan_clk or posedge reset) begin
        if(reset) currentState <= IDLE;
        else currentState <= nextState;
    end
    
    
    always @ (currentState or startScan or writeORread or didUpdateRowValue or scan_done or update_done or read_timer or last_row) begin
        case(currentState) 
        IDLE: begin
            if(startScan & ~writeORread) nextState = UPDATE_VALUE;
            else if (startScan & writeORread) nextState = PRECHARGE_BEFORE_READ;
            else nextState = IDLE;
        end
        
        UPDATE_VALUE: begin
            if(didUpdateRowValue) nextState = WRITE;
            else nextState = UPDATE_VALUE;
        end
        
        WRITE: begin
            if(scan_done) nextState = UPDATE;
            else nextState = WRITE;
        end
        UPDATE: begin
            if(update_done) begin
                if(!last_row) nextState = UPDATE_VALUE;
                else nextState = IDLE;  //change the state here
            end
            else nextState = UPDATE;     
        end
        
        PRECHARGE_BEFORE_READ: begin
            nextState = FIRE_RWL;
        end
        FIRE_RWL: begin
            nextState = FIRE_SA_for_READ;
        end
        FIRE_SA_for_READ: begin
            
            if(read_timer < 2) begin
                nextState = FIRE_SA_for_READ;
            end
            else begin
               nextState = SCANOUT;
            end
        end
        SCANOUT: begin
            if(scan_done) begin
                if(~last_row) nextState = PRECHARGE_BEFORE_READ;
                else nextState = IDLE;
            end
            else nextState = SCANOUT;
        end        
        endcase
    end    
    
    
    always @ (negedge scan_clk or posedge reset) begin
        if(reset) begin
            scan_clk_EN <= 0;
            scanin <= 0;
            scan_done <= 0;
            currentAccessRow <= 0;
            update_clk_EN <= 0;
            se <= 0;   
            thisRowValue <= 0;
            didUpdateRowValue <= 0;
            update_count <= 0;
            update_done <= 0;
            last_row <= 0;
            this_scancol <= 0;
            WE <= 0;
            SA_EN <= 0;
            PCHR <= 1;
            read_timer <= 0;
            DRAM_normalMode_EN <= 0;
            RBL_EN_normal <= 0;
            RBL_bar_EN_normal <= 0;
            chip_reset_fromScan <= 1;
            
        end
        else begin
            case(currentState) 
            IDLE: begin
                scan_clk_EN <= 0;
                scanin <= 0;
                scan_done <= 0;
                currentAccessRow <= 0;
                update_clk_EN <= 0;
                se <= 0;   
                thisRowValue <= 0;
                didUpdateRowValue <= 0;
                update_count <= 0;
                update_done <= 0;
                last_row <= 0;
                this_scancol <= 0;
                
                WE <= 0;
                SA_EN <= 0;
                PCHR <= 1;
                
                DRAM_normalMode_EN = 0;
                RBL_EN_normal <= 0;
                RBL_bar_EN_normal <= 0;
                
                chip_reset_fromScan <= 1;
                
                ONE_BANK_HEIGHT <= 5'd3;
//                totalScanData[0] <= ONE_BANK_HEIGHT << 101 | inputData[0];
//                totalScanData[1] <= ONE_BANK_HEIGHT << 101 | inputData[1];
//                totalScanData[2] <= ONE_BANK_HEIGHT << 101 | inputData[2];
                
//                totalScanData[3] <= ONE_BANK_HEIGHT << 101 | inputData[3];
//                totalScanData[4] <= ONE_BANK_HEIGHT << 101 | inputData[4];
//                totalScanData[5] <= ONE_BANK_HEIGHT << 101 | inputData[5];
                
            end
            UPDATE_VALUE: begin
            
//                thisRowValue <= totalScanData[currentAccessRow];
                thisRowValue <= (annealing_data << 106) | (ONE_BANK_HEIGHT << 101) | inputData[currentAccessRow];
                didUpdateRowValue <= 1;
                update_count <= 0;
                update_done <= 0;
            end
            WRITE: begin
                last_row <= 0;
                se <= 1;
                update_done <= 0;
                if(this_scancol < write_maxCol) begin 
                    scan_clk_EN <= 1'b1; 
                    scanin <= thisRowValue[this_scancol]; 
                    this_scancol <= this_scancol + 1; 
                end 
                else begin 
                    this_scancol <= 0; 
                    didUpdateRowValue <= 0;  
                    scan_done <= 1; 
                    scan_clk_EN <= 1'b0; 
                end     
            end
            
            UPDATE: begin
                WE <= 1;
                SA_EN <= 0;
                PCHR <= 1;
 
                se <= 0;
                scan_done <= 0;
                ///////////////////////
                if(update_count < 3) begin
                    chip_reset_fromScan <= 0;
                    DRAM_normalMode_EN = 1;
                    update_clk_EN <= 1;
                    update_count <= update_count + 1;
                end
                else begin
                    chip_reset_fromScan <= 1;
                    DRAM_normalMode_EN = 0;
                    update_clk_EN <= 0;
                    update_done <= 1;
                    if(currentAccessRow < write_maxRow-1) begin
                        last_row <= 1'b0;
                        scan_done <= 0; 
                        currentAccessRow <= currentAccessRow + 1;
                    end
                    else begin
                        last_row <= 1'b1;
                        scan_done <= 1; 
                        currentAccessRow <= 0;
                    end 
                end
            end
  
            PRECHARGE_BEFORE_READ: begin
                scan_done <= 0; 
                PCHR <= 0; // precharge
                
                WE <= 0;
                DRAM_normalMode_EN <= 0;
                SA_EN <= 0;
                
                RBL_EN_normal <= 1; //for read
                RBL_bar_EN_normal <= 0; //for read
                
            end
            FIRE_RWL: begin
                PCHR <= 1;
                DRAM_normalMode_EN <= 1;
                WE <= 0;
                SA_EN <= 0;
//                currentAccessRow;
            end
            FIRE_SA_for_READ: begin
                DRAM_normalMode_EN <= 0;
                SA_EN <= 1;
                read_timer <= read_timer + 1;
            end
            SCANOUT: begin
                read_timer <= 0;
                if(this_scancol > 1) begin
                    SA_EN <= 0;
//                    PCHR <= 0;
                    RBL_EN_normal <= 0;
                    RBL_bar_EN_normal <= 0;
                end
                
                if(this_scancol < read_maxCol) begin 
                    scan_clk_EN <= 1'b1; 
                    this_scancol <= this_scancol + 1; 
                    if(this_scancol == 0) se <= 0;
                    else if (this_scancol == 1) begin
                        se <= 1;
                    end
                end
                else begin 
                    se <= 0;
                    this_scancol <= 0; 
                    scan_done <= 1; 
                    scan_clk_EN <= 1'b0; 
                    if(currentAccessRow < read_maxRow-1) begin
                        last_row <= 1'b0;
                        currentAccessRow <= currentAccessRow + 1;
                    end
                    else begin
                        last_row <= 1'b1;
                    end
                end  
                
            end

            
            endcase
        end
    
    end    
    
    
endmodule
