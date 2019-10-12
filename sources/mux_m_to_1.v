module mux_m_to_1(select, in, y);
    parameter NUMBER_OF_INPUT = 4;
    parameter NUMBER_OF_SELECT = 2; // which is log(NUMBER_OF_INPUT)
    input [NUMBER_OF_SELECT-1:0] select;
    input [NUMBER_OF_INPUT-1:0] in;
    output y;

    assign y = in[select];
endmodule
