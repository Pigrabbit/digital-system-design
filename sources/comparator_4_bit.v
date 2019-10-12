module comparator_4_bit(i_a_gt_b, i_a_eq_b, i_a_lt_b, a, b, o_a_gt_b, o_a_eq_b, o_a_lt_b);
    input i_a_gt_b, i_a_eq_b, i_a_lt_b;
    input [3:0] a, b;
    output o_a_gt_b, o_a_eq_b, o_a_lt_b;
    
    assign o_a_eq_b = (a == b) && i_a_eq_b;
    assign o_a_gt_b = (a > b) || ((a == b) && i_a_gt_b);
    assign o_a_lt_b = (a < b) || ((a == b) && i_a_lt_b);
endmodule