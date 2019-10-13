`timescale 1ns/1ps
module zero_count_function_tb;
    reg [7:0] data;
    wire [3:0] out;

    zero_count_function dut (
        .data(data),
        .out(out)
    );

    initial begin
        data = 8'b0000_0000;
        #10
        data = 8'b0000_0001;
        #10
        data = 8'b0000_0011;
        #10
        data = 8'b0000_0111;
        #10
        data = 8'b0000_1111;
        #10
        data = 8'b0001_1111;
        #10
        data = 8'b0011_1111;
        #10
        data = 8'b0111_1111;
        #10
        data = 8'b1111_1111;
        #10
        $finish;
    end

endmodule
