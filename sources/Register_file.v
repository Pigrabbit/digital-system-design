module register_file(Addr_A, Addr_B, WR, CLK, RSTn, Data_in, Src, Dest);
input [3:0] Addr_A, Addr_B;
input WR, CLK, RSTn;
input [15:0] Data_in;

output reg [15:0] Src, Dest;

reg [15:0] register_file [7:0];
integer i;

always @(negedge RSTn) begin
    for(i = 0; i < 8; i = i + 1)
        register_file[i] <= 16'h0;
end

always @(posedge CLK) begin
    if(WR)
        register_file[Addr_B] <= Data_in;
        
    Src <= register_file[Addr_A];
    Dest <= register_file[Addr_B];
end

endmodule
