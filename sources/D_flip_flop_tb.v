`timescale 1ns / 1ps

module D_flip_flop_tb();
    reg D, CLK, RESET;
    wire Q;
    
    D_flip_flop uut (
        .D(D),
        .CLK(CLK),
        .RESET(RESET),
        .Q(Q)
    );

    initial begin
        RESET = 1'b1;
        #20 RESET = 1'b0;
    end
    initial begin
        CLK = 1'b0;
        forever #10 CLK = ~CLK;
    end
    initial begin
        D <= 0;
        forever #40 D = ~D;
    end
endmodule
