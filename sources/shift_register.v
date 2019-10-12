module shift_register(serial_in, clk, rst_n, q);
// serial data in & parallel data out
    input serial_in, clk, rst_n;
    output reg [3:0] q;

    always @(posedge clk) begin
        if (rst_n) q <= 4'b0000;
        else q <= {q[2:0], serial_in};
    end
endmodule
