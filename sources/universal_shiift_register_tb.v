`timescale 1ns/1ps;
module universal_shift_register_tb;
    localparam integer size = 4;
    reg clk, reset_n, select_1, select_0, left_serial_in, right_serial_in;
    reg [size - 1:0] data_in;
    wire [size - 1:0] q_out;

    universal_shift_register dut (
        .clk(clk),
        .reset_n(reset_n),
        .select_1(select_1),
        .select_0(select_0),
        .left_serial_in(left_serial_in),
        .right_serial_in(right_serial_in),
        .data_in(data_in),
        .q_out(q_out)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk <= ~clk;
    end

    initial begin
        reset_n = 1'b0;
        {select_1, select_0} = 2'b00;
        left_serial_in = 1'b0;
        right_serial_in = 1'b0;
        data_in = 4'b0010;
        #20
        // s1, s0 = (0, 1)
        // right shift
        // expect 1001
        reset_n = 1'b1;
        select_0 = 1'b1;
        left_serial_in = 1'b1;
        right_serial_in = 1'b1;
        #20
        // s1, s0 = (1, 0)
        // left shift
        // expect 0101
        select_1 = 1'b1;
        select_0 = 1'b0;
        #20
        // s1, s0 = (1, 1)
        // load data
        // expect 1111
        select_0 = 1'b1;
        data_in = 4'b1111;
        #20
        $finish;
    end
endmodule