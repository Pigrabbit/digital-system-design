module register_load_and_reset(clk, load, reset_n, data_in, q_out);
    parameter SIZE = 4;
    input clk, load, reset_n;
    input [SIZE-1:0] data_in;
    output reg [SIZE-1:0] q_out;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) q_out <= {SIZE{1'b0}};
        else if (load) q_out <= data_in;
    end
endmodule
