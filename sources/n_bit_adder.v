module n_bit_adder(x, y, c_in, sum, c_out);
    parameter N = 4;
    input [N-1:0] x, y;
    input c_in;
    output [N-1:0] sum;
    output c_out;

    genvar i;
    wire [N-2:0] c;

    generate for(i = 0; i < N; i = i + 1) begin: adder
        case (i)
            0: assign {c[i], sum[i]} = x[i] + y[i] + c_in;
            N-1: assign {c_out, sum[i]} = x[i] + y[i] + c[i-1];
            default: assign {c[i], sum[i]} = x[i] + y[i] + c[i-1];
        endcase
        end 
    endgenerate
endmodule
