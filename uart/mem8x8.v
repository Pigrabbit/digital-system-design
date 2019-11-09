`timescale 1ns / 1ps

module mem8x8
(
    input               clk, 
    input               rstn,    
    input               r_valid,             
    input        [7:0]  in_data,                   
    input               t_rdy,
    input               rx_done,
    output              empty, 
    output              full,            
    output              r_rdy,
    output  reg         t_valid,     
    output  reg [7:0]   out_data    
); 

    reg [3:0]   t_cnt;
    reg [3:0]   r_cnt;      
    reg [7:0]   mem [0:7];   
    
    assign empty    = (t_cnt==4'h9)? 1'b1:1'b0;   
    assign full     = (r_cnt==4'h8)? 1'b1:1'b0;
    assign r_rdy    = (!full)? 1'b1:1'b0; 

    always @ (posedge clk or negedge rstn) begin 
        if (!rstn)   begin
            r_cnt <= 4'h0;
            t_cnt <= 4'h0;
        end
        else begin
        // receive
            if (~full && r_valid) begin
               r_cnt <= r_cnt + 1;
            end                    
            else if (full) begin
                r_cnt <= 0;
            end
        // transmit
            if (~empty && t_rdy) begin
               t_cnt <= t_cnt + 1;
            end
            else if( full) begin
                t_cnt <= t_cnt + 1;
            end                    
            else if (empty) begin
                t_cnt <= 0;
            end                                                               
        end
     end
    
    // receive
    always @ (posedge clk or negedge rstn) begin 
        if (!rstn)   begin
        end
        else begin
            if (r_valid && ~full) begin
                mem[r_cnt] <= in_data;
            end
            else begin
                mem[r_cnt] <= mem[r_cnt];
            end                                                   
        end
     end

    // transmit
    always @ (posedge clk or negedge rstn) begin
        if (!rstn)   begin
            out_data <= {8{1'b0}}; 
            t_valid <= 1'b0;                   
        end
        else begin                      
            if (~empty && t_rdy) begin
                out_data <= mem[t_cnt];
                
                if (rx_done)
                    t_valid <= 0;
                else
                    t_valid <= 1;
            end
            else begin
                if (full) begin
                    out_data <= mem[t_cnt];
                    t_valid <= 1;
                end
                else begin
                    out_data <= out_data;
                    if (rx_done)
                        t_valid <= 0;
                end
            end
        end
    end
    

endmodule