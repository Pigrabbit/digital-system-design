/* 	
This is verilog code for 8-stage multiplier with two 8-bit signed numbers.
*/

module multiplier (
                    A,		// Signed 8 bit
                    B,		// Signed 8 bit
                    clk,
                    sum);
	
	input	[7:0]      A;
	input	[7:0]      B;
	input              clk;
	output reg	[15:0] sum;
    	
	// Internal Wires	
	wire   [7:0]   A_mag;         
    wire   [7:0]   B_mag;
	wire   [7:0]   p1, p2, p3, p4, p5, p6, p7, p8;		// partial product
	wire   [5:0]   lsb_sum21, lsb_sum22, lsb_sum23, lsb_sum24;
	wire   [4:0]   msb_sum31, msb_sum32, msb_sum33, msb_sum34;
	wire   [9:0]   sum31, sum32, sum33, sum34;
	wire   [7:0]   lsb_sum41, lsb_sum42;
	wire   [4:0]   msb_sum51, msb_sum52;
	wire   [11:0]  sum51, sum52;
	wire   [9:0]   lsb_sum6;
	wire   [6:0]   msb_sum7;      
	wire   [15:0]  sum_unsigned;
	wire           sign;           
	
	// Internal Registers
	reg    [7:0]   A_reg;
	reg    [7:0]   p1_reg, p2_reg, p3_reg, p4_reg, p5_reg, p6_reg, p7_reg, p8_reg;
	reg    [5:0]   lsb_sum21_reg, lsb_sum22_reg, lsb_sum23_reg, lsb_sum24_reg;
	reg    [7:4]   p2_msb, p4_msb, p6_msb, p8_msb;
	reg    [7:5]   p1_msb, p3_msb, p5_msb, p7_msb;
	reg    [9:0]   sum31_reg, sum32_reg, sum33_reg, sum34_reg;
	reg    [7:0]   lsb_sum41_reg, lsb_sum42_reg;
	reg    [9:7]   msb_41, msb_43;
	reg    [9:5]   msb_42, msb_44;
	reg    [11:0]  sum51_reg, sum52_reg;
	reg    [9:0]   lsb_sum6_reg;
	reg    [11:9]  msb_61;
	reg    [11:5]  msb_62;
	reg    [15:0]  sum_unsigned_reg;
	reg            sign_s1, sign_s2, sign_s3, sign_s4, sign_s5, sign_s6, sign_s7;	// sign bit
          
		
	// Stage 1: Partial Products
	// Take the Magnitude of Signed Numbers. 	
    assign A_mag = A[7] ? ~A[7:0] + 1 : A[7:0];               
    assign B_mag = B[7] ? ~B[7:0] + 1 : B[7:0];  
	///////////////////////////////////////////////////////
	// TODO: insert value to each p using "A_mag" and "B_mag"
	assign p1 = A_mag * B_mag[0];
	assign p2 = A_mag * B_mag[1];
	assign p3 = A_mag * B_mag[2];
	assign p4 = A_mag * B_mag[3];
	assign p5 = A_mag * B_mag[4];
	assign p6 = A_mag * B_mag[5];
	assign p7 = A_mag * B_mag[6];
	assign p8 = A_mag * B_mag[7];
	///////////////////////////////////////////////////////
	
	///////////////////////////////////////////////////////
    // TODO: insert value to sign(sign of multiplication result)	
	assign sign = A[7] ^ B[7];  
	///////////////////////////////////////////////////////
	
	always @(posedge clk) begin
		p1_reg <= p1;
		p3_reg <= p3;
		p5_reg <= p5;
		p7_reg <= p7;
		p2_reg <= p2;
		p4_reg <= p4;
		p6_reg <= p6;
		p8_reg <= p8;
		sign_s1 <= sign;                              
	end
	
	
	// Stage 2: Add LSBs
	///////////////////////////////////////////////////////
    // TODO: insert value to each lsb_sum2x using "px_reg"
	// lsb_sum2x are 6 bits
	assign lsb_sum21 = p1_reg[4:0] + {p2_reg[3:0], 1'b0};
	assign lsb_sum22 = p3_reg[4:0] + {p4_reg[3:0], 1'b0});  
	assign lsb_sum23 = p5_reg[4:0] + {p6_reg[3:0], 1'b0});  
	assign lsb_sum24 = p7_reg[4:0] + {p8_reg[3:0], 1'b0};  
	///////////////////////////////////////////////////////

	always @(posedge clk) begin	
		lsb_sum21_reg <= lsb_sum21;
		lsb_sum22_reg <= lsb_sum22;
		lsb_sum23_reg <= lsb_sum23;
		lsb_sum24_reg <= lsb_sum24;
		
		p1_msb <= p1_reg[7:5];
		p2_msb <= p2_reg[7:4];
		p3_msb <= p3_reg[7:5];
		p4_msb <= p4_reg[7:4];
		p5_msb <= p5_reg[7:5];
		p6_msb <= p6_reg[7:4];
		p7_msb <= p7_reg[7:5];
		p8_msb <= p8_reg[7:4];
		
		sign_s2 <= sign_s1;                   
	end


	// Stage 3: Add MSBs
	///////////////////////////////////////////////////////
    // TODO: insert value to each msb_sum3x using "px_msb" and "lsb_sum2x_reg"
	// lsb_sum2x_reg is 6 bit long
	assign msb_sum31 = p1_msb + p2_msb + lsb_sum21_reg[5];
	assign msb_sum32 = p3_msb + p4_msb + lsb_sum22_reg[5];
	assign msb_sum33 = p5_msb + p6_msb + lsb_sum23_reg[5];
	assign msb_sum34 = p7_msb + p8_msb + lsb_sum24_reg[5];
	///////////////////////////////////////////////////////
	
	assign sum31 = {msb_sum31[4:0], lsb_sum21_reg[4:0]};
	assign sum32 = {msb_sum32[4:0], lsb_sum22_reg[4:0]};
	assign sum33 = {msb_sum33[4:0], lsb_sum23_reg[4:0]};
	assign sum34 = {msb_sum34[4:0], lsb_sum24_reg[4:0]};
	
	always @(posedge clk) begin
		sum31_reg <= sum31;
		sum32_reg <= sum32;
		sum33_reg <= sum33;
		sum34_reg <= sum34;
	
		sign_s3 <= sign_s2;                   
	end
	
	
	// Stage 4: Add LSBs, shift bits two times.
	///////////////////////////////////////////////////////
    // TODO: insert value to each lsb_sum4x using "sum3x_reg"
	assign lsb_sum41 = sum31_reg[6:0] + {sum32_reg[4:0], 2{1'b0}};
	assign lsb_sum42 = sum33_reg[6:0] + {sum34_reg[4:0], 2{1'b0}};   
	///////////////////////////////////////////////////////
	
	always @(posedge clk) begin
		lsb_sum41_reg <= lsb_sum41;
		lsb_sum42_reg <= lsb_sum42;
		
		msb_41 <= sum31_reg[9:7];
		msb_42 <= sum32_reg[9:5];
		msb_43 <= sum33_reg[9:7];
		msb_44 <= sum34_reg[9:5];
	
		sign_s4 <= sign_s3;               
	end
	
	
	//Stage 5: Add MSBs
	///////////////////////////////////////////////////////
    // TODO: insert value to each msb_sum5x using "msb_4x" and "lsb_sum4x_reg"
	assign msb_sum51 = msb_41 + msb_42 + lsb_sum41_reg[7];
	assign msb_sum52 = msb_43 + msb_44 + lsb_sum42_reg[7];
	///////////////////////////////////////////////////////
	
	assign sum51 = {msb_sum51[4:0], lsb_sum41_reg[6:0]};
	assign sum52 = {msb_sum52[4:0], lsb_sum42_reg[6:0]};
	
	always @(posedge clk) begin
		sum51_reg <= sum51;
		sum52_reg <= sum52;

		sign_s5 <= sign_s4;               
	end
	
	
	// Stage 6: Add LSBs, shift bits 4 times.
	///////////////////////////////////////////////////////
    // TODO: insert value to lsb_sum6 using "sum5x_reg"
	assign lsb_sum6 = sum51_reg[8:0] + {sum52_reg[4:0], 4{1'b0}};
	///////////////////////////////////////////////////////
   
	always @(posedge clk) begin
		lsb_sum6_reg <= lsb_sum6;

		msb_61 <= sum51_reg[11:9];
		msb_62 <= sum52_reg[11:5];            
	
		sign_s6 <= sign_s5;               
	end
	
	// Stage 7: Add MSBs
	///////////////////////////////////////////////////////
    // TODO: insert value to sum_unsigned using "msb_6x" and "lsb_sum6_reg"
	assign msb_sum7 = msb_61 + msb_62 + lsb_sum6_reg[9];
	///////////////////////////////////////////////////////
	
	assign sum_unsigned = {msb_sum7, lsb_sum6_reg[8:0]};             
	
	always @(posedge clk) begin
		sum_unsigned_reg <= sum_unsigned;                     
		
		sign_s7 <= sign_s6;                                  
	end
	
	// Stage 8: Take the Result of Multiplication
	///////////////////////////////////////////////////////
    // TODO: insert value to sum for each condition using "sum_unsigned_reg"
	always @(posedge clk) begin
		if(sign_s7==1'b0) // if result is positive
			sum <= sum_unsigned_reg;
		else // if result is negative
			sum <= ~sum_unsigned_reg[15:0] + 1;
	///////////////////////////////////////////////////////

	end
	
endmodule