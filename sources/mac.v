`timescale 1ns / 1ps

module MAC #(

    parameter integer A_BITWIDTH = 8,
    parameter integer B_BITWIDTH = A_BITWIDTH,
    parameter integer OUT_BITWIDTH = 16,
    parameter integer C_BITWIDTH = A_BITWIDTH,
    parameter integer C_EXTEN_BITWIDTH = 2*C_BITWIDTH-1
    
)
(
    
    input                                   CLK,
    input                                   EN,
    input                                   RSTn,
    input [A_BITWIDTH-1:0]                  DATA_A, 
    input [B_BITWIDTH-1:0]                  DATA_B,
    input [C_BITWIDTH-1:0]                  DATA_C,
    output reg [OUT_BITWIDTH-1:0]           MOUT,
    output reg                              DONE
    );

localparam 
    STATE_IDLE = 2'b00, 
    STATE_MULT = 2'b01, 
    STATE_Addx = 2'b10,
    STATE_Done = 2'b11;
    
reg [1:0]                       m_state;
wire [C_EXTEN_BITWIDTH-1:0] data_c_exten;

// data_c_exten is Extended DATA_C
// Because C is added with A*B, both of C and A*B have same fraction bits (12bit = 2^-12) and better to have same # of bits
// DATA_C's fraction is  6bit(2^-6), So modify it.
assign data_c_exten = {DATA_C[7],1'b0,DATA_C[6:0], 6'b000000};  


// sequential task: updating the state
always @( posedge CLK or negedge RSTn) begin
    if(!RSTn) begin
        m_state <= 2'b00;
    end
    else begin
        case(m_state)
            STATE_IDLE: begin
                if(EN && !DONE) begin
                // TO DO
                // If EN is high and DONE != 1, then running state.
                end
                else begin
                // TO DO
                // If not, just waiting for condition.
                end
            end
            STATE_MULT: begin
                // TO DO
                // If multiply calculation done, move to add state
            end
            STATE_Addx: begin
                // TO DO
                // If add calculation done, move to done state
            end
            STATE_Done: begin
                // TO DO
                // move to idle state
            end
            default:;
           
        endcase
    end
end
                    
// combinational logic: determine the value of the machine's output
always @ (posedge CLK or negedge RSTn) begin
    if(!RSTn) begin
        MOUT <={OUT_BITWIDTH{1'b0}};
        DONE <= 1'b0;
    end

    // implement multiply and adder freely
    // In this module, you can modify everything except input/outputs
    // MOUT = A*B + data_c_exten
    else begin
        case(m_state)
            STATE_IDLE: begin
            // TO DO
            // Done flag reset!
            end
            
            STATE_MULT: begin
            // TO DO
            // Do multiply
            end
            
            STATE_Addx: begin
            // TO DO
            // Do add
            end 
            STATE_Done: begin
            // TO DO
            // make output 'DONE' flag high.( DONE = 1)
            end
            default:;
       endcase
   end
end
endmodule
