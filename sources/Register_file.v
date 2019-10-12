`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/09/27 13:15:14
// Design Name: 
// Module Name: register_file
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_file(Addr_A, Addr_B, WR, CLK, RSTn, Data_in, Src, Dest);
input [3:0] Addr_A, Addr_B;
input WR, CLK, RSTn;
input [15:0] Data_in;

output reg [15:0] Src, Dest;

reg [15:0] rf[7:0];
integer i;

always @(negedge RSTn) begin
    for(i = 0; i < 8; i = i + 1)
        rf[i] <= 2'h00;
end

always @(posedge CLK) begin
    if(WR)
        rf[Addr_B] <= Data_in;
        
    Src <= rf[Addr_A];
    Dest <= rf[Addr_B];
end

endmodule
