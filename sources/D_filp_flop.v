module D_flip_flop (D, RESET, CLK, Q);
    // D flip-flop with synchronous reset
    input D, RESET, CLK;
    output reg Q;   

    always @(posedge CLK) 
        if(RESET) Q <= 1'b0;
        else Q <= D;
endmodule
