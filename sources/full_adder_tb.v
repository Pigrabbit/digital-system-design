`timescale 1ns/1ps;
module full_adder_tb;
    reg x, y, c_in;
    wire s, c_out;

    full_adder dut (
        .x(x),
        .y(y),
        .c_in(c_in),
        .s(s),
        .c_out(c_out)
    );

    initial begin
        x = 1'b0;
        y = 1'b0;
        c_in = 1'b0;
        #10
        c_in = 1'b1;
        #20
        y = 1'b1;
        c_in = 1'b0;
        #30
        c_in = 1'b1;
        #40
        x = 1'b1;
        y = 1'b0;
        c_in = 1'b0;
        #50
        c_in = 1'b1;
        #60
        y = 1'b1;
        c_in = 1'b0;
        #70
        c_in = 1'b1;
        #20
        $finish;
    end
endmodule
