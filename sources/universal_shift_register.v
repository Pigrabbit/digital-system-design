module universal_shift_register(clk, reset_n, select_1, select_0, left_serial_in, right_serial_in, data_in, q_out);
    parameter SIZE = 4;
    input clk, reset_n, select_1, select_0, left_serial_in, right_serial_in;
    input [SIZE-1:0] data_in;
    output reg [SIZE-1:0] q_out;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) q_out <= {SIZE{1'b0}};
        else case ({select_1, select_0})
            2'b00: q_out <= q_out;
            2'b01: q_out <= {left_serial_in, data_in[SIZE-1:1]};
            2'b10: q_out <= {data_in[SIZE-2:0], right_serial_in};
            2'b11: q_out <= data_in;
        endcase
    end
endmodule
