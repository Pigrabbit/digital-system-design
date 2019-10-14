module output_logic (
    input        CLOCK,
    input        FLEFT,
    input        FRED,
    input        FYELLOW,
    input        HGREEN,
    input        HLEFT,
    input        HRED,
    input        HYELLOW,

    output [7:0] LED
    );

    assign LED[7] = CLOCK;
    assign LED[6] = HRED;
    assign LED[5] = HYELLOW;
    assign LED[4] = HLEFT;
    assign LED[3] = HGREEN;
    assign LED[2] = FRED;
    assign LED[1] = FYELLOW;
    assign LED[0] = FLEFT;

endmodule

