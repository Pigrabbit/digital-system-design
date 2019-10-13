`timescale 1ns/1ps;
module gray_to_binary_tb;
    localparam integer size = 4;
    reg [size - 1: 0] gray;
    wire [size - 1: 0] binary;

    gray_to_binary dut (
        .gray(gray),
        .binary(binary)
    );

    initial begin
        gray = 4'b0000;
        $display($realtime,,"The binary value %b", binary);
        #10
        gray = 4'b0001;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        gray = 4'b0011;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        gray = 4'b0010;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        gray = 4'b0110;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        gray = 4'b0111;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        gray = 4'b0101;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        gray = 4'b0100;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        gray = 4'b1100;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        gray = 4'b1101;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        gray = 4'b1111;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        gray = 4'b1110;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        gray = 4'b1010;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        gray = 4'b1011;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        gray = 4'b1001;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        gray = 4'b1000;
        $display($realtime,,"The binary vaule %b", binary);
        #10
        $finish;
    end
endmodule