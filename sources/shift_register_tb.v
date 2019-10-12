`timescale 1ns/1ps;
module shift_register_tb;
    reg serial_in, clk, rst_n;
    wire [3:0] q;

    shift_register dut (
        .serial_in(serial_in),
        .clk(clk),
        .rst_n(rst_n),
        .q(q)
    );

    initial begin
        serial_in = 1'b0;
        clk = 1'b0;
        rst_n = 1'b1;
        #10 
        serial_in = 1'b1;
        rst_n = 1'b0;
        #10
        serial_in = 1'b0;
        #50
        rst_n = 1'b1;
        #10
        $finish;
    end

    always #5 clk = ~clk;
endmodule
