`timescale 1ns/1ps;
module n_bit_adder_tb;
    parameter N = 4;
    reg [N-1:0] x, y;
    reg c_in;
    wire [N-1:0] sum;
    wire c_out;

    n_bit_adder dut (
        .x(x),
        .y(y),
        .c_in(c_in),
        .sum(sum),
        .c_out(c_out)
    );

    initial begin
        x = 4'b0000;
        y = 4'b0000;
        c_in = 1'b0;
        #10
        // 1000 + 0010 = 1010
        x = 4'b1000;
        y = 4'b0010;
        #10
        // 1100 + 1001 = 1 0101
        x = 4'b1100;
        y = 4'b1001;
        #10
        // 0010 + 0001 + 1 = 0100
        x = 4'b0010;
        y = 4'b0001;
        c_in = 1'b1;
        #10
        $finish;
    end

endmodule
