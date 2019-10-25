`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/19 17:34:13
// Design Name: 
// Module Name: tb
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


module tb();
parameter CLK_CYCLE = 5;

reg clk;
reg rstn;
reg r_valid;
reg [31:0] data_input;
wire [7:0] d_a;
wire [7:0] d_b;
wire [7:0] d_c;
wire [7:0] data_output;
wire t_valid;
wire read_done;
always #CLK_CYCLE clk = ~clk;

initial begin

    //////1st///////
    clk  = 0;
    rstn = 0;
    r_valid = 1'b0;
    data_input = 32'd0;
    repeat(10)
        @(posedge clk);
    rstn = 1;
    data_input = {8'd0,8'd9,8'b00010100,8'b10000101};
    r_valid = 1'b1;

    wait(read_done);
    repeat(1)
        @(posedge clk);
    r_valid = 1'b0;
    if({8'd0,d_c,d_b,d_a} == data_input) begin
      $display("[BRAM] Result1 is correct!");
    end
    else begin
      $display("[BRAM] Result1 is incorrect!");
    end
    wait(t_valid);
    repeat(1)
            @(posedge clk);
    if(data_output == 8'b00000111) begin
        $display("[MAC] Result1 is correct!");
    end
    else begin
        $display("[MAC] Result1 is incorrect!");
    end
    
    //////2nd///////
    
    r_valid = 1'b0;
    data_input = 32'd0;
    repeat(10)
        @(posedge clk);
 
    data_input = {8'd0,8'd3,8'b01000000,8'd7};
    r_valid = 1'b1;

    wait(read_done);
    repeat(1)
        @(posedge clk);
    r_valid = 1'b0;
    if({8'd0,d_c,d_b,d_a} == data_input) begin
      $display("[BRAM] Result2 is correct!");
    end
    else begin
      $display("[BRAM] Result2 is incorrect!");
    end
    wait(t_valid);
    repeat(1)
            @(posedge clk);
    if(data_output == 8'b00001010) begin
        $display("[MAC] Result2 is correct!");
    end
    else begin
        $display("[MAC] Result2 is incorrect!");
    end
    
    //////3rd///////   
    r_valid = 1'b0;
    data_input = 32'd0;
    repeat(10)
        @(posedge clk);
 
    data_input = {8'd0,8'b10000011,8'b11000001,8'b10001001};
    r_valid = 1'b1;

    wait(read_done);
    repeat(1)
        @(posedge clk);
    r_valid = 1'b0;
    if({8'd0,d_c,d_b,d_a} == data_input) begin
      $display("[BRAM] Result3 is correct!");
    end
    else begin
      $display("[BRAM] Result3 is incorrect!");
    end
    wait(t_valid);
    repeat(1)
            @(posedge clk);
    if(data_output == 8'b00000110) begin
        $display("[MAC] Result3 is correct!");
    end
    else begin
        $display("[MAC] Result3 is incorrect!");
    end
    
    $finish;
end
sample_controller u_sample_controller(
    .clk(clk),
    .rstn(rstn),
    .r_valid(r_valid),
    .in_data(data_input),
    .out_data(data_output),
    .t_valid(t_valid),
    .d_a(d_a),
    .d_b(d_b),
    .d_c(d_c),
    .read_done(read_done)
);
endmodule
