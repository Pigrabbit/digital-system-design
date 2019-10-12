module full_adder(x, y, c_in, s, c_out);
    input x, y, c_in;
    output s, c_out;

    wire s1, c1, c2;
    
    half_adder_structural ha1 (.x(x), .y(y), .s(s1), .c(c1));
    half_adder_structural ha2 (.x(s1), .y(c_in), .s(s), .c(c2));
    or (c_out, c1, c2);
endmodule
