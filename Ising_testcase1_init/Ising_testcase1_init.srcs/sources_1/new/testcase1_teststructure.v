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
    
    output sys_clk,
    
    output reg PCHR, 
    output reg SA_EN,
    output reg [2:0] WBL_test,
    output reg RBL_EN,
    output reg [5:0] RWL,
    output reg REF_CTRL_WL
    );
    
    //parameter
    parameter IDLE = 0;
    parameter PRECHARGE = 1;
    parameter REF_GEN = 2;
    parameter load_J1 = 3;
    parameter load_J2 = 4;
    parameter load_J3 = 5;
    parameter ISING_PREP = 6;
    parameter ISING_COMPARE = 7;
    
    //spin
    parameter [8:0] spin = 9'b011101111;
    //J coefficient
    parameter [8:0] J = 9'b111101111;
    
    //reg
    reg [3:0] currentState, nextState;
    reg [8:0] idle_counter;
    
    
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
    
    always @ (negedge sys_clk or posedge fpga_reset) begin
        if(fpga_reset) currentState <= IDLE;
        else currentState <= nextState;
    end
    
    always @ (currentState or idle_counter) begin
    case (currentState) 
    IDLE: begin
        if(idle_counter < 2) begin
           nextState = IDLE;
        end
        else begin
            nextState = PRECHARGE;
        end
    end
    PRECHARGE: begin
        nextState = REF_GEN;
    end
    REF_GEN: begin
        nextState = load_J1;
       
    end
    load_J1: begin
         nextState = load_J2;
    end
    load_J2: begin
         nextState = load_J3;
    end
    load_J3: begin
         nextState = ISING_PREP;
    end 
    ISING_PREP: begin
        nextState = ISING_COMPARE;
    end
    ISING_COMPARE: begin
        nextState = IDLE;
    end
    endcase 
    
    end
    
    always @ (negedge sys_clk) begin
        case(currentState) 
        REF_GEN: begin
            REF_CTRL_WL = 1'b0;
        end
        load_J1: begin
            RWL = 6'b0;
        end
        load_J2: begin
            RWL = 6'b0;
        end
        load_J3: begin
            RWL = 6'b0;
        end
        endcase
    end
    
    always @ (posedge sys_clk or posedge fpga_reset) begin
        if(fpga_reset) begin
            RWL = 6'b0;
            PCHR = 1'b1;
            SA_EN = 1'b0;
            RBL_EN = 1'b0;
            WBL_test = 3'b0;
            REF_CTRL_WL = 1'b0;
            idle_counter = 0;
        end
    else begin
        case(currentState)
        IDLE: begin
            RWL = 6'b0;
            PCHR = 1'b1;
            SA_EN = 1'b0;
            RBL_EN = 1'b0;
            WBL_test = 3'b0;
            REF_CTRL_WL = 1'b0; 
            
            if(idle_counter < 100) begin
                idle_counter <= idle_counter + 1;
            end
            else begin
                idle_counter <= 0;
            end
        end
        
        PRECHARGE: begin
            PCHR = 1'b0;
            SA_EN = 1'b0;
        end
        REF_GEN: begin
            REF_CTRL_WL = 1'b1;
            PCHR = 1'b1;
        end
        load_J1: begin
            PCHR = 1'b1;
            SA_EN = 1'b0;
            
            RWL = ( (J[8:6]^3'b111) << 3 ) | J[8:6];
            WBL_test = spin[8:6];
        end
        load_J2: begin
            PCHR = 1'b1;
            SA_EN = 1'b0;
            
            RWL = ((J[5]^1'b1) << 5 ) | (0 << 4 ) | ((J[5]^1'b1) << 3 ) | J[5:3];
            WBL_test = spin[5:3];
        end
        load_J3: begin
            PCHR = 1'b1;
            SA_EN = 1'b0;
            
            RWL = ( (J[2:0]^3'b111) << 3 ) | J[2:0];
            WBL_test = spin[2:0];
        end
        ISING_PREP: begin
            RWL = 6'b0;
            RBL_EN = 1'b1;
        end
        ISING_COMPARE: begin
            RWL = 6'b0;
            SA_EN = 1'b1;
            RBL_EN = 1'b0;
        end
        endcase
    end    
    end 
    
    
    
endmodule
