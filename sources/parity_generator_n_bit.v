module parity_generator_n_bit(x, even_parity, odd_parity);
    parameter N = 9;
    input [N-1:0] x;
    output even_parity, odd_parity;

    assign even_parity = ^x;
    assign odd_parity = ~even_parity;
endmodule
