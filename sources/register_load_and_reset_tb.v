`timescale 1ns/1ps;
module register_load_and_reset_tb;
    localparam integer size = 4;
    reg [size-1:0] data_in;
    reg clk, load, reset_n;
    wire [size-1:0] q_out;

    register_load_and_reset dut (
        .clk(clk),
        .load(load),
        .reset_n(reset_n),
        .data_in(data_in),
        .q_out(q_out)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        load = 1'b0;
        reset_n = 1'b0;
        data_in = 4'b0011;
        #10
        load = 1'b1;
        reset_n = 1'b1;
        #10
        data_in = 4'b1100;
        #10
        load = 1'b0;
        #10
        data_in = 4'b0000;
        #10
        reset_n = 1'b0;
        #10
        $finish;
    end
endmodule