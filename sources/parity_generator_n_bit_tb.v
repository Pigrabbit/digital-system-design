`timescale 1ns/1ps;
module parity_generator_n_bit_tb;
    localparam integer n = 9;
    reg [n-1:0] x;
    wire even_parity, odd_parity;

    parity_generator_n_bit dut (
        .x(x),
        .even_parity(even_parity),
        .odd_parity(odd_parity)
    );

    initial begin
        x = 9'b000000111;
        #10
        x = 9'b000001111;
        #10
        x = 9'b111111111;
        #10
        x = 9'b111111110;
        #10
        $finish;
    end

endmodule
