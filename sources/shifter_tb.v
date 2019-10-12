`timescale 1ns / 100ps
module shifter_tb ();

   wire [15:0] OUT;
   reg [15:0] INPUT;
   reg [4:0] RLamount;
   reg LUI;
   integer flag;

   shifter shifter1 (	.in(INPUT), 
						.RLamount(RLamount),
						.lui(LUI),
						.out(OUT)
					);

   initial
   begin:stimuli
       flag = 1;
	   INPUT = 16'b1000_0000_0000_0001;
	   LUI = 1'b0;
	   RLamount = 5'b00011;
	#5 if(OUT!=16'h0008) begin
	       flag = 0;
	   end
	#5 RLamount = 5'b00110;
	#5 if(OUT!=16'h0040) begin
           flag = 0;
       end
	#5 RLamount = 5'b01101;
	#5 if(OUT!=16'h2000) begin
           flag = 0;
       end
	#5 RLamount = 5'b10010;
	#5 if(OUT!=16'h0002) begin
           flag = 0;
       end
	#5 RLamount = 5'b10111;
	#5 if(OUT!=16'h0040) begin
           flag = 0;
       end
	#5 RLamount = 5'b11001;
	#5 if(OUT!=16'h0100) begin
           flag = 0;
       end
	#5 LUI = 1'b1;
	#5 if(OUT!=16'h0100) begin
           flag = 0;
       end
	#5 RLamount = 5'b00111;
	#5 if(OUT!=16'h0100) begin
           flag = 0;
       end
	#5 RLamount = 5'b01001;
	#5 if(OUT!=16'h0100) begin
           flag = 0;
       end
 	#5 RLamount = 5'b10101;
 	#5 if(OUT!=16'h0100) begin
           flag = 0;
       end
       if(flag) begin
        $display("[Result]: Result is correct");
       end
       else begin
        $display("[Result]: Result is incorrect");
       end
       $finish;
	end
  
    
    
endmodule