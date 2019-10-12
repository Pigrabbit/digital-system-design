`timescale 1ns / 1ps
module half_adder_structural_tb;
    reg x, y;
    wire s, c;

    half_adder_structural dut (
        .x(x),
        .y(y),
        .s(s),
        .c(c)
    );

    initial begin
        x = 1'b0;
        y = 1'b0;
        # 10
        y = 1'b1;
        # 20
        x = 1'b1;
        y = 1'b0;
        # 30
        y = 1'b1;
        $finish;
    end
endmodule