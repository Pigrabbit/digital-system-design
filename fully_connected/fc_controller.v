///////////////////////////////////////////////
/*
You can edit or write the code as you want, except for the marked points (Not allowed to change).
Rules you have to keep:
1. Input size and output size of this fully connected layer is fixed (Input : 8, Output: 4) 
2. The input data, weights, bias will be stored in BRAM at each start address (INPUT_START_ADDRESS, WEIGHT_ADDRESS, BIAS_ADDRESS) by STATE_DATA_RECEIVE.
3. You can get input data, weights, bias from BRAM in fixed sizes. Please check and use reg variables; input_data, weight, bias. You cannot edit the size of these variables. Especially, you should know that you cannot get all weights from BRAM at once.
4. When the values are calculated in this module, partial summations (temperal results) must not be quantized. Only the final results (outputs) should quantize to 8-fixed bits.
5. The output of this FC model will be 4 and each of them is 1 byte. When the all calculation is done, you should put the 4 results in out_data(32-bits) and set t_valid as 1. Please check STATE_DATA_SEND in lab6 code.


You can use just one FSM or more than one FSM. In other words, you can use just 'state' or you can use 'b_state' for bram operating and 'c_state' for calculation operating.
*/
//////////////////////////////////////////////


`timescale 1ns / 1ps

module sample_controller(
input clk,
input rstn,
input r_valid,
input [31:0] in_data,
output reg [31:0] out_data,
output reg t_valid
);
localparam      
                STATE_IDLE       	= 3'd0,
                STATE_DATA_RECEIVE   = 3'd1,
                STATE_INPUT_SET    = 3'd2,
                STATE_BIAS_SET    = 3'd3,
                STATE_WEIGHT_SET  = 3'd4,
                STATE_ACCUMULATE = 3'd5,
                STATE_BIAS_ADD = 3'd6,
                STATE_DATA_SEND = 3'd7,

                /////////////////////* Not allowed to change */////////////////////
                // FC layer parameters
                INPUT_SIZE = 8,	// byte
                OUTPUT_SIZE = 4,	// byte
                BYTE_SIZE = 8,
                BIAS_SIZE = OUTPUT_SIZE,	// byte
                WEIGHT_SIZE = INPUT_SIZE*OUTPUT_SIZE,	// byte
                
                
                // In BRAM
                INPUT_START_ADDRESS = 4'b0000,
                WEIGHT_START_ADDRESS = 4'b0100,
                BIAS_START_ADDRESS = 4'b1110;
//                OUTPUT_START_ADDRESS = 4'b1100;
                ///////////////////////////////////////////////////////////////////
                


/////////////////////* Not allowed to change */////////////////////
//for DATA
reg [INPUT_SIZE*BYTE_SIZE-1:0]          			input_data;	     // input feature size = 8 (each 8-bits)
reg [INPUT_SIZE*BYTE_SIZE-1:0]     					  weight;		       // weight size = 8 * 4 (each 8-bits). However just set 64-bits(8bytes) at one time.
reg [BIAS_SIZE*BYTE_SIZE-1:0]          				bias;			       // bias size = 4 (each 8-bits)
///////////////////////////////////////////////////////////////////
reg [INPUT_SIZE*BYTE_SIZE-1:0]                input_data_buffer;
reg [INPUT_SIZE*BYTE_SIZE-1:0]                weight_buffer;

// For BRAM Operation
reg [2:0]           b_state;
reg [3:0]           addr;
reg [31:0]          din;
wire [31:0]         dout;
reg                 bram_en;
reg                 we;
reg [2:0]           delay;
reg                 b_write_done;
reg                 input_set_done;
reg                 weight_set_done;
reg                 bias_set_done;
reg	 [15:0]					bram_counter;
reg                 data_ready;       // When BRAM Operation completes to set buffers.

// For FC Calculation Operation with MAC module
reg [2:0]           c_state;
reg                 acc_en;
reg                 bias_en;
wire [18:0]         bias_in;
reg [7:0]           data_a;
reg [7:0]           data_b;
reg [18:0]          data_c;
wire                acc_done;
wire                bias_done;
reg [3:0]           iter;
reg [18:0]          partial_sum;
wire [18:0]         result_acc;
wire [19:0]         result_bias;
wire [7:0]          result_q;
reg                 data_set_done;  // When Calculation Operation completes to set datas from buffers.
reg [3:0]           out_counter;    // This indicates N of N-th output
reg [2:0]           weight_counter;


assign bias_done = acc_done;
/* You can use MAC as you want. So, you can use just one MAC or several MACs for parallelism.*/

mac #(.A_BITWIDTH(8), .OUT_BITWIDTH(19))
 u_acc_sum (
   .clk(clk),
   .en(acc_en),
   .rstn(rstn),
   .data_a(data_a), 
   .data_b(data_b),
   .data_c(data_c),
   .mout(result_acc),
   .done(acc_done)
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
    delay <= 2'b00;
    addr <= 4'b1111;   // 4'b1111 is dump address(not be used)
    din <= 8'd0;
    b_write_done <= 1'b0;
    input_set_done <= 1'b0;
    weight_set_done <= 1'b0;
    bias_set_done <= 1'b0;
    bram_counter <= 16'h0000;
    weight_counter <= 3'b0;
    data_ready <= 1'b0;
    input_data <= {INPUT_SIZE*BYTE_SIZE{1'b0}};
    weight <= {INPUT_SIZE*BYTE_SIZE{1'b0}};
    bias <= {BIAS_SIZE*BYTE_SIZE{1'b0}};
    b_state <= STATE_IDLE;
  end

  else begin
    case(b_state)
      STATE_IDLE: begin
        bram_en <= 1'b0;
        we <= 1'b0;
        b_write_done <= 1'b0;
        bram_counter <= 16'h0000;
        data_ready <= 1'b0;
        if(r_valid) begin
          b_state <= STATE_DATA_RECEIVE;
        end
      end
      
      /////////////////////* Not allowed to change except state */////////////////////
      // Receive data from testbench and write data to BRAM.
      STATE_DATA_RECEIVE: begin
        if(b_write_done) begin
          bram_en <= 1'b0;
          we <= 1'b0;
          addr <= 4'b1111;
          din <= 32'd0;
          b_write_done <= 1'b0;
          bram_counter <= 16'h0000;
          b_state <= STATE_INPUT_SET;       ///////////////////// Only this Line, you can Modify the state you made. ////////////////
        end
        else begin
          if(r_valid) begin
            bram_en <= 1'b1;
            we <= 1'b1;
            din <= in_data;
            bram_counter <= bram_counter + 16'h0001;
            if(bram_counter == 0) begin	// receive input by (input_size/4) times considering 32-bits data write.
              addr <= INPUT_START_ADDRESS;
            end
            else if(bram_counter == INPUT_SIZE[9:2]) begin	// receive weight by (weight_size/4) times considering 32-bits data write.
              addr <= WEIGHT_START_ADDRESS;
            end
            else if(bram_counter == WEIGHT_SIZE[9:2] + INPUT_SIZE[9:2]) begin	// receive bias by (bias_size/4) times considering 32-bits data write.
              addr <= BIAS_START_ADDRESS;
            end
            else if(bram_counter == BIAS_SIZE[9:2] + WEIGHT_SIZE[9:2] + INPUT_SIZE[9:2]) begin	// receive done
              b_write_done <= 1'b1;
            end
            else begin
              addr <= addr + 4'd1;
            end
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
      ///////////////////////////////////////////////////////////////////
      // To Do //
      STATE_INPUT_SET:  begin
        if(input_set_done) begin
          bram_en <= 1'b0;
          we <= 1'b0;
          addr <= 4'b1111;
          input_set_done <= 1'b0;
          bram_counter <= 16'h0000;
          b_state <= STATE_BIAS_SET;
        end
        else begin
          if (delay == 3'b000) begin
            bram_en <= 1'b1;
            we <= 1'b0;
            addr <= INPUT_START_ADDRESS;
            delay <= delay + 3'b001;
          end
          else if(delay == 3'b001) begin
            delay <= delay + 3'b001;
          end
          else if(delay == 3'b010) begin
            input_data[31:0] <= dout;
            addr <= addr + 16'h0001;
            delay <= delay + 3'b001;
          end
          else if(delay == 3'b011) begin
            delay <= delay + 3'b001;
          end
          else if(delay == 3'b100) begin
            input_data[63:32] <= dout;
            input_set_done <= 1'b1;
            bram_en <= 1'b0;
            addr <= 4'b1111;
            delay <= 3'b00;
          end
        end
      end

      STATE_BIAS_SET: begin
        if(bias_set_done) begin
          bram_en <= 1'b0;
          we <= 1'b0;
          addr <= 4'b1111;
          bias_set_done <= 1'b0;
          bram_counter <= 16'h0000;
          b_state <= STATE_WEIGHT_SET;
        end
        else begin
          if (bram_counter == 16'h0000) begin
            bram_en <= 1'b1;
            we <= 1'b0;
            addr <= BIAS_START_ADDRESS;
            bram_counter <= bram_counter + 16'h0001;
          end
          else if(bram_counter == 16'h0001) begin
            bram_counter <= bram_counter + 16'h0001;
          end
          else if(bram_counter == 16'h0002) begin
            bias <= dout;
            bias_set_done <= 1'b1;
            bram_en <= 1'b0;
            addr <= 4'b1111;
            bram_counter <= 16'h0000;
          end
        end
      end

      STATE_WEIGHT_SET: begin
         if(weight_set_done && weight_counter >= OUTPUT_SIZE) begin
          bram_en <= 1'b0;
          we <= 1'b0;
          addr <= 4'b1111;
          weight_set_done <= 1'b0;
          weight_counter <= 3'b0;
          bram_counter <= 16'h0000;
          b_state <= STATE_IDLE;
        end
        else begin
          if (bram_counter == 16'h0000) begin
            data_set_done <= 1'b0;
            weight_set_done <= 1'b0;
            bram_en <= 1'b1;
            we <= 1'b0;
            addr <= WEIGHT_START_ADDRESS + 2 * weight_counter;
            bram_counter <= bram_counter + 16'h0001;
          end
          else if(bram_counter == 16'h0001) begin
            bram_counter <= bram_counter + 16'h0001;
          end
          else if(bram_counter == 16'h0002) begin
            weight[31:0] <= dout;
            addr <= addr + 16'h0001;
            bram_counter <= bram_counter + 16'h0001;
          end
          else if(bram_counter == 16'h0003) begin
            bram_counter <= bram_counter + 16'h0001;
          end
          else if(bram_counter == 16'h0004) begin
            weight[63:32] <= dout;
            weight_set_done <= 1'b1;
            data_ready <= 1'b1;
            if(data_set_done) begin
              bram_counter <= 16'h0000;
              data_set_done <= 1'b0;
              weight_counter <= weight_counter + 3'b1;
              bram_en <= 1'b0;
              addr <= addr + 16'h0001;
            end
          end
        end
      end
    endcase
end
end


//For FC Calculation operating 
// To Do //
always @(posedge clk or negedge rstn) begin
  if(!rstn) begin 
    c_state <= STATE_IDLE;
    acc_en <= 1'b0;
    t_valid <= 1'b0;
    iter <= 4'b0000;
    data_a <= 8'b0;
    data_b <= 8'b0;
    data_c <= 19'b0;
    partial_sum <= 19'b0;
    data_set_done <= 1'b0;
    out_counter <= 4'b0000;
    weight_buffer <= {INPUT_SIZE*BYTE_SIZE{1'b0}};
  end
  else begin
    case(c_state)      
      STATE_IDLE: begin
        data_a <= 8'b0;
        data_b <= 8'b0;
        data_c <= 19'b0;
        if(data_ready) begin
          input_data_buffer <= input_data;
          weight_buffer <= weight;
          data_set_done <= 1'b1;
          c_state <= STATE_ACCUMULATE;
        end
        else begin
          c_state <= STATE_IDLE;
        end
      end
      
      STATE_ACCUMULATE: begin
        if(iter > INPUT_SIZE) begin
          acc_en <= 1'b0;
          iter <= 4'b0000;
          data_c <= 19'b0;
          c_state <= STATE_BIAS_ADD;
        end
        else begin
          // do accumulate
          if (iter == 4'b0000) begin
            acc_en <= 1'b1;
            data_a <= input_data_buffer[BYTE_SIZE-1:0];
            data_b <= weight_buffer[BYTE_SIZE-1:0];
            data_c <= 19'b0;

            input_data_buffer <= input_data_buffer >> BYTE_SIZE;
            weight_buffer <= weight_buffer >> BYTE_SIZE;
      
            iter <= iter + 4'b0001;
          end
          else if (acc_done) begin
            data_a <= input_data_buffer[BYTE_SIZE-1:0];
            data_b <= weight_buffer[BYTE_SIZE-1:0];  
            data_c <= result_acc;

            input_data_buffer <= input_data_buffer >> BYTE_SIZE;
            weight_buffer <= weight_buffer >> BYTE_SIZE;
            partial_sum <= result_acc;
            iter <= iter + 4'b0001;
          end
        end
      end

      STATE_BIAS_ADD: begin
        if(bias_done && bias_en) begin
          if(out_counter < OUTPUT_SIZE) begin
            acc_en <= 1'b0;
            bias_en <= 1'b0;
            case(out_counter)
              4'b0000: begin
                if (result_acc[17:13] == 5'b11111 || result_acc[17:14] == 5'b00000) begin
                  out_data[7] <= result_acc[18];
                  out_data[6:0] <= result_acc[12:6];  
                end
                else if(result_acc[18] == 1) begin
                  out_data[7:0] <= 8'b1000_0000;
                end
                else begin
                  out_data[7:0] <= 8'b0111_1111;
                end
                out_counter <= out_counter + 4'b0001;
                bias <= bias >> BYTE_SIZE;
                c_state <= STATE_IDLE;
              end

              4'b0001: begin
                if (result_acc[17:13] == 5'b11111 || result_acc[17:14] == 5'b00000) begin
                  out_data[15] <= result_acc[18];
                  out_data[14:8] <= result_acc[12:6];
                end
                else if(result_acc[18] == 1) begin
                  out_data[15:8] <= 8'b1000_0000;
                end
                else begin
                  out_data[15:8] <= 8'b0111_1111;
                end
                out_counter <= out_counter + 4'b0001;
                bias <= bias >> BYTE_SIZE;
                c_state <= STATE_IDLE;
              end

              4'b0010: begin
                if (result_acc[17:13] == 5'b11111 || result_acc[17:14] == 5'b00000) begin
                  out_data[23] <= result_acc[18];
                  out_data[22:16] <= result_acc[12:6];
                end
                else if(result_acc[18] == 1) begin
                  out_data[23:16] <= 8'b1000_0000;
                end
                else begin
                  out_data[23:16] <= 8'b0111_1111;
                end
                out_counter <= out_counter + 4'b0001;
                bias <= bias >> BYTE_SIZE;
                c_state <= STATE_IDLE;
              end

              4'b0011: begin
                if (result_acc[17:13] == 5'b11111 || result_acc[17:14] == 5'b00000) begin
                  out_data[31] <= result_acc[18];
                  out_data[30:24] <= result_acc[12:6];
                end
                else if(result_acc[18] == 1) begin
                  out_data[31:24] <= 8'b1000_0000;
                end
                else begin
                  out_data[31:24] <= 8'b0111_1111;
                end
                bias <= bias >> BYTE_SIZE;
                out_counter <= 4'b0000;
                c_state <= STATE_DATA_SEND;
              end
            endcase
          end
        end
        else begin
          acc_en <= 1'b1;

          data_a <= bias[BYTE_SIZE-1:0];
          data_b <= 8'b0100_0000;
          data_c <= partial_sum; 

          if (acc_done) begin
            bias_en <= 1'b1;
          end        
        end
      end

      STATE_DATA_SEND: begin
        if(t_valid) begin
          t_valid <= 1'b0;
          out_data <= 32'b0;
          c_state <= STATE_IDLE;
        end
        else begin
          t_valid <= 1'b1;
          c_state <= STATE_DATA_SEND;
        end
      end

      default: begin
		  end
    endcase
  end
end



endmodule
