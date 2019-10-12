`timescale 1ns/1ps;
module comparator_4_bit_tb;
    reg i_a_gt_b, i_a_eq_b, i_a_lt_b;
    reg [3:0] a, b;
    wire o_a_gt_b, o_a_eq_b, o_a_lt_b;

    comparator_4_bit dut (
        .i_a_gt_b(i_a_gt_b),
        .i_a_eq_b(i_a_eq_b),
        .i_a_lt_b(i_a_lt_b),
        .a(a),
        .b(b),
        .o_a_gt_b(o_a_gt_b),
        .o_a_eq_b(o_a_eq_b),
        .o_a_lt_b(o_a_lt_b)
    );

    initial begin
        i_a_eq_b = 1'b1;
        i_a_gt_b = 1'b0;
        i_a_lt_b = 1'b0;
        a = 4'b0000;
        b = 4'b0000;
        #10
        i_a_eq_b = 1'b0;
        i_a_gt_b = 1'b1;
        #10
        i_a_gt_b = 1'b0;
        i_a_lt_b = 1'b1;
        #10
        i_a_lt_b = 1'b0;
        i_a_eq_b = 1'b1;
        a = 4'b0101;
        #10
        b = 4'b1000;
        #10
        a = 4'b1111;
        b = 4'b1111;
        #10
        $finish;
    end
endmodule
