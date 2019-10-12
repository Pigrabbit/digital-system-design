`timescale 1ns/1ps;
module decoder_n_to_m_tb;
    localparam integer number_of_input = 3;
    localparam integer number_of_output = 8;
    
    reg [number_of_input-1:0] x;
    reg enable;
    wire [number_of_output-1:0] y;

    decoder_n_to_m dut (
        .x(x),
        .enable(enable),
        .y(y)
    );

    initial begin
        x = 3'b000;
        enable = 1'b1;
        #10
        x = x + 1'b1;
        #10
        x = x + 1'b1;
        #10
        x = x + 1'b1;
        #10
        x = x + 1'b1;
        #10
        x = x + 1'b1;
        #10
        x = x + 1'b1;
        #10
        x = x + 1'b1;
        #10
        enable = 1'b0;
        #10
        $finish;
    end
endmodule
