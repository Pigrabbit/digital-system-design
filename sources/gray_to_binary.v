module gray_to_binary(gray, binary);
    parameter SIZE = 4;
    input [SIZE-1:0] gray;
    output reg [SIZE-1:0] binary;

    integer i;
    always @(*) begin
        for (i = SIZE - 1; i >= 0; i = i - 1)
            if (i == SIZE - 1) binary[i] = gray[i];
            else binary[i] = gray[i] ^ binary[i +1]; 
    end
endmodule
