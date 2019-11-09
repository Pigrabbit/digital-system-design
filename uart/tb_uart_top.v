`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/06 21:29:39
// Design Name: long
// Module Name: tb_uart_top
// Project Name: uart_test 
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


module tb_uart_top;

reg 	      sys_clk;
reg 	      rstn;
reg          btn;
reg 	      RxD;		
wire 	      TxD;

reg [63:0]  i_data;
reg [63:0]  o_data;

uart_top
#(
    .baud_rate_count(108),
    .threshold(20)
) u_uart_top
(
    .clk(sys_clk),
    .rstn(rstn),
    .btn(btn),
    .RxD(RxD),		
    .TxD(TxD)
);    

always #5 sys_clk = ~sys_clk;

initial begin
    sys_clk = 0;
    rstn = 1;
    RxD = 1;
    i_data = 0;
    o_data = 0; 
    btn = 0;  
    
    
//------------------//
//----- Test 1 -----//
//------------------//    
    
    repeat (5)
    @ (posedge sys_clk);
    rstn = 0;
    i_data = 64'h0123_4567_89ab_cdef; 
    
    repeat (5)
    @ (posedge sys_clk);
    rstn = 1;
    
    send_8bit(i_data[63:56]);
    send_8bit(i_data[55:48]);
    send_8bit(i_data[47:40]);
    send_8bit(i_data[39:32]);
    send_8bit(i_data[31:24]);
    send_8bit(i_data[23:16]);
    send_8bit(i_data[15:8]);
    send_8bit(i_data[7:0]);

    btn = 1;
    repeat (150)
    @ (posedge sys_clk);
    btn = 0;
    
    receive_8bit (o_data[63:56]);
    receive_8bit (o_data[55:48]);
    receive_8bit (o_data[47:40]);
    receive_8bit (o_data[39:32]);
    receive_8bit (o_data[31:24]);
    receive_8bit (o_data[23:16]);
    receive_8bit (o_data[15:8]);
    receive_8bit (o_data[7:0]);
    
    if (i_data == o_data) begin
        $display ("*******************");
        $display ("Test 1 is correct !!");
        $display ("*******************");
    end
    else begin
        $display ("*******************");
        $display ("Test 1 is ERROR !!");
        $display ("*******************");
    end
        

    repeat (100000)
    @ (posedge sys_clk);
    
//------------------//
//----- Test 2 -----//
//------------------//
    
    repeat (5)
    @ (posedge sys_clk);
    rstn = 0; 
    i_data = 64'hef01_2345_6789_abcd;
          
    repeat (5)
    @ (posedge sys_clk);
    rstn = 1;
    
    send_8bit(i_data[63:56]);
    send_8bit(i_data[55:48]);
    send_8bit(i_data[47:40]);
    send_8bit(i_data[39:32]);
    send_8bit(i_data[31:24]);
    send_8bit(i_data[23:16]);
    send_8bit(i_data[15:8]);
    send_8bit(i_data[7:0]);

    btn = 1;
    repeat (150)
    @ (posedge sys_clk);
    btn = 0;
        
    receive_8bit (o_data[63:56]);
    receive_8bit (o_data[55:48]);
    receive_8bit (o_data[47:40]);
    receive_8bit (o_data[39:32]);
    receive_8bit (o_data[31:24]);
    receive_8bit (o_data[23:16]);
    receive_8bit (o_data[15:8]);
    receive_8bit (o_data[7:0]);
    
    if (i_data == o_data) begin
        $display ("*******************");
        $display ("Test 2 is correct !!");
        $display ("*******************");
    end
    else begin
        $display ("*******************");
        $display ("Test 2 is ERROR !!");
        $display ("*******************");
    end
        
    $finish;
end


task send_8bit (input [7:0] data);
    begin
         //  1byte UART data transmission in Pyserial is from LSB to MSB
         //  Data packet = (LSB) Start bit + Data frame[0:7] + Stop bit (MSB)

         // The UART data transmission line is normally held at a high voltage level when it?????s not transmitting data
         #1  RxD = 1;

         // Start bit is 0
         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  RxD = 0;


         //  Send the data frame - 8bit
         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  RxD = data[0];

         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  RxD = data[1];

         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  RxD = data[2];

         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  RxD = data[3];

         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  RxD = data[4];

         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  RxD = data[5];

         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  RxD = data[6];

         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  RxD = data[7];

         // Stop bit is 1
         repeat (108)
           @ (posedge sys_clk);
         #($random%1)   RxD = 1;

  end
endtask

task receive_8bit (output reg [7:0] dataout );
      begin
         wait ( TxD == 0)    // Start bit
           repeat (20)
             @ (posedge sys_clk);
         //  Send the data frame - 8bit
         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  dataout[0] = TxD;

         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  dataout[1] = TxD;

         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  dataout[2] = TxD;

         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  dataout[3] = TxD;

         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  dataout[4] = TxD ;

         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  dataout[5] = TxD;

         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  dataout[6] = TxD;

         repeat (108)
           @ (posedge sys_clk);
         #($random%1)  dataout[7] = TxD;

         // Stop bit is 1
         wait (TxD);

    end
endtask
   
endmodule
