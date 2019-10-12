`timescale 1ns/1ps;
module mux_m_to_1_tb;
    localparam integer number_of_input = 4;
    localparam integer number_of_select = 2;

    reg [number_of_select-1:0] select;
    reg [number_of_input-1:0] in;
    wire y;

    mux_m_to_1 dut (
        .select(select),
        .in(in),
        .y(y)
    );

    initial begin
        select = 2'b00;
        in = 4'b1010;
        #10
        select = 2'b01;
        #10
        select = 2'b10;
        #10
        select = 2'b11;
        #10
        $finish;
    end
endmodule
