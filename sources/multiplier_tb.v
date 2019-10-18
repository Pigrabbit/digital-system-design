`timescale 1ns / 1ps

module tb_multiplier;
    
    reg [7:0]   A;
    reg [7:0]   B;
    reg         clk = 1;
    wire [15:0] sum;
    
    reg is_correct;
    
    multiplier multiplier_0 (
        .A(A),		// Signed 8 bit
        .B(B),		// Signed 8 bit
        .clk(clk),
        .sum(sum)                                    
        );
    
    
    // clock
    initial forever
        #5 clk = ~clk;
    
    initial begin
    
        #5
        A = 8'b0000_0101;
        B = 8'b0000_0010;    
        
        #10
        A = 8'b0000_0100;
        B = 8'b1111_1001;    
        
        #10
        A = 8'b0111_1111;
        B = 8'b0111_1111;
    
        #10
        A = 8'b1000_0000;
        B = 8'b1000_0000;    
    
        #10
        A = 8'b0000_0101;
        B = 8'b0000_0010;    
        
        #10
        A = 8'b0000_0100;
        B = 8'b1111_0111;    
        
        #10
        A = 8'b1111_1001;
        B = 8'b1111_0110;    
    
        #10
        A = 8'b0000_0100;
        B = 8'b1111_0001;
        
        #10
        A = 8'b0000_0100;
        B = 8'b0000_0011;

    end
    
    
    initial begin
        
        is_correct = 1;
        
        #82
        if(sum != 16'h000a) is_correct = 0;
        
        #10
        if(sum != 16'hffe4) is_correct = 0;
        
        #10
        if(sum != 16'h3f01) is_correct = 0;   
        
        #10
        if(sum != 16'h4000) is_correct = 0;
        
        #10
        if(sum != 16'h000a) is_correct = 0;
    
        #10
        if(sum != 16'hffdc) is_correct = 0;
        
        #10
        if(sum != 16'h0046) is_correct = 0;
        
        #10
        if(sum != 16'hffc4) is_correct = 0;
        
        #10
        if(sum != 16'h000c) is_correct = 0;
        
        #10
        if(is_correct) $display("[Result]: Result is correct.");
        else $display("[Result]: Result is incorrect.");
        
        $finish;
    end
    
endmodule
