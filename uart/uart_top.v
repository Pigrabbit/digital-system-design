`timescale 1ns / 1ps

module uart_top
#(
    parameter baud_rate_count = 108,
    parameter threshold = 20
)
(
    input 	      clk,
    input 	      rstn,
    input         btn,
    input 	      RxD,		
    output 	      TxD,
    output [7:0]  in_data          
);

//    wire [7:0] 		 in_data;		
    wire [7:0] 		 out_data;
    wire 		     transmit;
    wire 		     receive;
    wire 		     r_done;
    wire 		     t_done;
    wire 		     empty;
    wire 		     full;
    wire             r_rdy;
    wire             r_valid;
    wire             t_rdy;
    wire             t_valid;
    wire            rx_done;
//    wire 		     t_signal;    // btn for transmition

receive_debouncing 
#(
    .threshold(threshold)
) u_receive_debouncing 
(
  .clk(clk),
  .rstn(rstn),
  .d_in(RxD),
  .done(r_done),
  .receive(receive)
);
   
receiver
#(
    .baud_rate_count(baud_rate_count)
) u_receiver 
(
     .clk(clk),
     .RxD(RxD),
     .rstn(rstn),
     .receive(receive),     
     .rdy(r_rdy),
     .valid(r_valid),
     .full(full),     
     .done(r_done),
     .data(in_data)
     

); 
               
transmit_debouncing
#(
    .threshold(threshold)
) u_transmit_debouncing 
(
    .clk(clk),
    .btn1(btn),
    .rstn(rstn),
    .transmit(transmit),
    .t_done(t_done)
);


transmitter
#(
    .baud_rate_count(baud_rate_count)
) u_transmitter 
(
    .clk(clk),
    .TxD(TxD),
    .rstn(rstn),
    .transmit(transmit),
    .rdy(t_rdy),
    .valid(t_valid),
    .rx_done(rx_done),
    .empty(empty),
    .done(t_done),
    .data(out_data)
    
);

mem8x8
    u_mem8x8
    (
        .clk(clk), 
        .rstn(rstn),  
        .empty(empty), 
        .full(full),                
        .r_rdy(r_rdy),
        .r_valid(r_valid),             
        .in_data(in_data),                       
        .t_rdy(t_rdy),
        .t_valid(t_valid),
        .rx_done(rx_done),     
        .out_data(out_data)    
    ); 
   
endmodule