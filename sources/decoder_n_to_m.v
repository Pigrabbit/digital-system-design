module decoder_n_to_m(x, enable, y);
    parameter NUMBER_OF_INPUT = 3;
    parameter NUMBER_OF_OUTPUT = 8; // 2 ** (NUMBER_OF_INPUT) = NUMBER_OF_OUTPUT

    input [NUMBER_OF_INPUT-1:0] x;
    input enable;
    output reg [NUMBER_OF_OUTPUT-1:0] y;

    always @(*) begin
        // use blocking assignment
        if (!enable) y = {NUMBER_OF_OUTPUT{1'b0}};
        else y = {{(NUMBER_OF_OUTPUT-1){1'b0}}, 1'b1} << x;
    end
endmodule
