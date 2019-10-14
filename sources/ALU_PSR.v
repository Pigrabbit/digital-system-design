
`timescale 1ns / 1ps
module ALU (
input [15:0] A,
input [15:0] B,
input [5:0] alu_sel,
output reg [15:0] out,
output reg [4:0] flcnz
) ;

reg carry_in;
wire Cflag,Fflag,Zflag,Nflag,Lflag;
wire [15:0] sum;
wire [15:0] cmp,and1,or1,xor1;


////////////////////////////////////////
//	TODO: insert right value for adder
CLA_16Bit cla16
(.A(A),
.B(B),
.C_in(carry_in),
.S(sum),
.C_out(Cflag),
.OF(Fflag)
);
/////////////////////////////////////////

              
always@* begin
	case (alu_sel)
/////////////////////////////////////////
// 	TODO: insert value to "carry_in" using case statement
//  add -> carry_in = 0
//  sub, cmp -> carry_in = 1
//  and, or, xor => carry_in = 0
        6'b010000 : carry_in <= 1'b1;
        6'b001000 : carry_in <= 1'b1;
        default : carry_in <= 1'b0;
	endcase
end
/////////////////////////////////////////    

//////////////////////////////////////////
// 	TODO: insert flag values 

assign and1 = A & B;
assign or1 = A | B;
assign xor1 = A ^ B;
assign Zflag = ~|sum;
assign Lflag = Cflag;
assign Nflag = Cflag ^ A[15] ^ B[15];
//////////////////////////////////////////

//////////////////////////////////////////
// 	TODO: insert value to "FLCNZ" and "out"
always@* begin
	case (alu_sel) 
        6'b100000 : begin // ADD
        ///// flags from fc, out = some value
            flcnz[4] = Fflag;
            flcnz[2] = Cflag;
            out = sum;
        end
        6'b010000 : begin // SUB
        ///// flags from fc, out = some value
            flcnz[4] = Fflag;
            flcnz[2] = Cflag;
            out = sum;
        end
        6'b001000 : begin // CMP
            if (Zflag) begin
			///// flags from lnz
                flcnz[3] = Lflag;
                flcnz[1] = Nflag;
                flcnz[0] = Zflag;
           	end
            else begin
            ///// flags from lnz
                flcnz[3] = Lflag;
                flcnz[1] = Nflag;
                flcnz[0] = Zflag;
            end
        end       
        6'b000100 : begin // AND
		///// out = some value
            out = and1;
		end
        6'b000010 : begin // OR
		///// out = some value
            out = or1;
		end
        6'b000001 : begin // XOR
		///// out = some value
            out = xor1;
		end
        default : begin
			flcnz = 5'b0;
			out = 16'b0;
		end
	endcase
end
endmodule
//////////////////////////////////////////

module PSR (
input [4:0] flag_in,
input [5:0] alu_sel,
input RESETn,
input CLK,
output [4:0] flag_out
);

reg [4:0] flag_reg;    

//////////////////////////////////////////
// 	TODO: update flag values to "flag_out"
always@(posedge CLK) begin
        if(~RESETn) begin
            flag_reg <= 0;
        end
        else begin
            case (alu_sel) 
            6'b100000 : begin
       		///// flag update
                flag_reg[4] <= flag_in[4];
                flag_reg[2] <= flag_in[2];
            end
            6'b010000 : begin
            ///// flag update
                flag_reg[4] <= flag_in[4];
                flag_reg[2] <= flag_in[2];
            end
            6'b001000 : begin
            ///// flag update
                flag_reg[3] <= flag_in[3];
                flag_reg[1] <= flag_in[1];
                flag_reg[0] <= flag_in[0];
            end
            default : ;
            endcase
        end
end
//////////////////////////////////////////

assign flag_out = flag_reg;

endmodule