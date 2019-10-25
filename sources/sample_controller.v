`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/19 10:23:56
// Design Name: jaewan choi 
// Module Name: sample_controller
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


module sample_controller(
input clk,
input rstn,
input r_valid,
input [31:0] in_data,
output reg [7:0] out_data,
output reg t_valid,
output [7:0] d_a,
output [7:0] d_b,
output [7:0] d_c,
output read_done
);
localparam      STATE_IDLE       = 3'b000,
                STATE_BRAM_WRITE = 3'b001,
                STATE_BRAM_READ  = 3'b010,
                STATE_RUNNING    = 3'b011,
                STATE_DATA_SEND  = 3'b100;
 // STATE_BRAM_WRITE: Receive data from testbench and write data to BRAM.
 // STATE_BRAM_READ: Read data from BRAM
 // STATE_RUNNING: Run MAC operation
 // STATE_DATA_SEND: Send result data to testbench.

assign d_a = data_a;
assign d_b = data_b;
assign d_c = data_c;
assign read_done = b_read_done;

reg [2:0]           state;   
reg [1:0]           delay;

// For MAC module
reg                 mac_en;
reg [7:0]           data_a;
reg [7:0]           data_b;
reg [7:0]           data_c;
wire                mac_done;
wire [15:0]         result;
reg [7:0]           result_reg;

// For BRAM
reg [3:0]           addr;
reg [31:0]          din;
wire [31:0]         dout;
reg                 bram_en;
reg                 we;        
reg                 b_read_done;
reg                 b_write_done;

MAC #(.A_BITWIDTH(8), .OUT_BITWIDTH(16))
  u_MAC (
    .CLK(clk),
    .EN(mac_en),
    .RSTn(rstn),
    .DATA_A(data_a), 
    .DATA_B(data_b),
    .DATA_C(data_c),
    .MOUT(result),
    .DONE(mac_done)
);
sram_32x16 u_sram_32x16(
    .addra(addr),
    .clka(clk),
    .dina(din),
    .douta(dout),
    .ena(bram_en),
    .wea(we)
);


//For BRAM operating  
always @(posedge clk or negedge rstn) begin

  if(!rstn) begin
    bram_en <= 1'b0;
    we <= 1'b0;
    addr <= 4'b1111;   // 4'b1111 is dump address(not be used)
    din <= 8'd0;
    b_read_done <= 0;
    b_write_done <= 0;
    delay <= 2'b00;
    data_a <= 8'd0;
    data_b <= 8'd0;
    data_c <= 8'd0;
  end
  else begin
    if(state == STATE_BRAM_WRITE) begin 
      if(b_write_done) begin
        bram_en <= 1'b0;
        we <= 1'b0;
        addr <= 4'b1111;
        din <= 32'd0;
        b_write_done <= 1'b0;
      end
      else begin
        if(r_valid) begin
          bram_en <= 1'b1;
          we <= 1'b1;
          addr <= 4'b0000;
          din <= in_data;
          b_write_done <= 1'b1;
        end
        else begin
          bram_en <= 1'b0;
          we <= 1'b0;
          addr <= 4'b1111;   // dump value
          din <= 32'd0;
          b_write_done <= 1'b1;
        end
      end  
    end
    else if(state == STATE_BRAM_READ) begin
      // #####################
      // TO DO
      // #####################
      if(b_read_done) begin
      // read 하고 나서
        data_a <= dout[7:0];
        data_b <= dout[15:8];
        data_c <= dout[23:16];
        bram_en <= 1'b0;
        addr <= 4'b1111;
        b_read_done <= 1'b0;
      end
      else begin
      // read 하는 operation
        bram_en <= 1'b1;
        we <= 1'b0;
        addr <= 4'b0000;
        // 결과를 받은 후 flag를 1로 바꿈
        @(posedge clk) b_read_done <= 1'b1;
      end
    end
    else begin
      bram_en <= 1'b0;
      we <= 1'b0;
      addr <= 4'b1111;
      b_write_done <= 1'b0;
      b_read_done <= 1'b0;
    end

  end

end



// Control path
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin 
       state <= STATE_IDLE;
       mac_en <= 1'b0;
       t_valid <= 1'b0;
    end
    else begin
        case(state) 
        STATE_IDLE: begin 
            t_valid <= 1'b0;
            if(r_valid) begin
                state <= STATE_BRAM_WRITE; 
            end
            else begin
                state <= STATE_IDLE;
            end
        end
        STATE_RUNNING: begin 
            if(mac_done) begin
                state <= STATE_DATA_SEND;
                mac_en <= 1'b0;
            end
            else begin
                mac_en <= 1'b1;
                state <= STATE_RUNNING;
            end
        end
        STATE_DATA_SEND: begin 
          if(t_valid) begin
            t_valid <= 1'b0;
            state <= STATE_IDLE;
          end
          else begin
            t_valid <= 1'b1;
            state <= STATE_DATA_SEND;
          end
        end
        default: begin
          if(b_write_done && state == STATE_BRAM_WRITE) begin
            state <= STATE_BRAM_READ;
          end
          else if(b_read_done && state == STATE_BRAM_READ) begin
            state <= STATE_RUNNING;
          end
          else begin end
        end
        endcase
    end
end

//data path

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        out_data <= {8{1'b0}};
        result_reg <= {8{1'b0}};
    end
    else begin
        case(state) 
            STATE_IDLE: begin  end
            
            STATE_RUNNING: begin 
                if(mac_done) begin // quantization
                    result_reg[7] <= result[15];
                    if(|result[14:13] == 1) begin
                        result_reg[6:0] <= 7'b1111111;
                    end
                    else begin
                        result_reg[6:0] <= result[12:6];
                    end
                end
                else begin
                    result_reg <= result_reg;
                end
            end
            STATE_DATA_SEND: begin
                out_data <= result_reg;
            end
            
        endcase
    end
end
 
    


endmodule
