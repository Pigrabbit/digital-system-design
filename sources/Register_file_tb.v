`timescale 1ns / 100ps
module Register_file_tb;

    
    wire [15:0] SRC, DEST;

    reg [3:0] ADDR_A, ADDR_B;
    reg [15:0] DATA_IN;
    reg WR, CLK, RSTn;
    

    register_file dut
	 ( .CLK(CLK),
	.RSTn(RSTn),
	.Addr_A(ADDR_A),
	.Addr_B(ADDR_B),
	.Data_in(DATA_IN),
	.WR(WR),
	.Src(SRC), 
	.Dest(DEST)
	); 
     
       
    initial forever 
    #5 CLK = ~CLK; 
    
    initial 
    begin

        CLK=1; 

        RSTn = 1;
        #2 	RSTn = 0;
        WR=0;
        ADDR_A=4'd0;
        ADDR_B=4'd0;
        #20 	RSTn = 1;


	////////// WRITE /////////
        
        ADDR_A = 4'b0000; 		// Select R0
        ADDR_B = 4'b0001; 		// Select R1
            
        #20 	DATA_IN = 16'h1234;

        #20 	WR = 1;			// Write to R1
        #10 	WR = 0; 


        #20 	ADDR_B = 4'b0111;		// Select R7
            
        #20 	DATA_IN = 16'h5678;

        #20 	WR = 1;			// Write to R7
        #10 	WR = 0;
     

	///////////////////////////



	/////////// READ //////////
        
        #20 	ADDR_A = 4'b0100;		// Read R4
	 	ADDR_B = 4'b0101;		// Read R5
            
        #20 	ADDR_A = 4'b0111;		// Read R7

        #20 	ADDR_B = 4'b0001;		// Read R1

	////////////////////////////

        
        #20 	RSTn = 0;
        #20 	RSTn = 1;
                
        #40
        $finish; 
    end
    
    
endmodule



