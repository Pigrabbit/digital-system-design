`timescale 1ns / 1ps


module transmitter
#(
    parameter baud_rate_count= 108
)
(
    input clk, 
    input rstn,
    input transmit, 
    input [7:0] data,
    input empty,
    input valid,         
    output reg rdy,
    output reg  rx_done,        
    output reg TxD,  
    output reg done
);
    localparam IDLE = 0;
    localparam TX = 1;

    reg [3:0] bitcounter; //4 bits counter to count up to 10
    reg [13:0] counter; //14 bits counter to count the baud rate, counter = clock / baud rate
    reg state;
    reg nextstate;      
    reg [9:0] rightshiftreg; 
    reg shift; //shift signal to start bit shifting in UART
    reg load; //load signal to start loading the data into rightshift register and add start and stop bit
    reg clear; //clear signal to start reset the bitcounter for UART transmission

    reg flag;
    reg transmit_delay;
        
    always @ (posedge clk or negedge rstn) begin
        if (!rstn) begin 
            transmit_delay <= 1'b0;                        
        end
        else begin
            if (transmit)
                transmit_delay <= 1'b1;
            if (empty)
                transmit_delay <= 1'b0;    
        end    
    end
                           
    always @ (posedge clk or negedge rstn)  begin 
        if (!rstn) begin 
            counter <={31{1'b0}}; 
            flag <= 1'b0;    
        end
        else if (transmit) begin
            counter <= {31{1'b0}};
            flag <= 1'b0;
        end
        else begin
            if ( counter >= baud_rate_count) begin
                counter <= 0;
                flag <= 1;                    
            end
            else begin
                counter <= counter + 1;
                flag <= 0;
            end
        end
    end

    
    //UART transmission logic
    always @ (posedge clk or negedge rstn) 
    begin 
        if (!rstn) begin 
                state <=IDLE; 
                bitcounter <= 4'h0; 
                rightshiftreg <= {10{1'b0}};
                rdy <= 0;
                rx_done  <= 0;
        end
        else begin
            if(done) begin
                done <= 0;
                rdy <= 0;
            end
            else begin
                if (flag) begin 
                    state <= nextstate; 
                    if (load && valid ) begin
                        rightshiftreg <= {1'b1,data,1'b0}; 
                        rx_done <= 1;
                    end
                    else 
                        rx_done <= 0;                    
                    if (clear) begin 
                        bitcounter <=0; 
                    end
                    if (shift)  begin 
                        rightshiftreg <= rightshiftreg >> 1;
                        bitcounter <= bitcounter + 1;                     
                        if(bitcounter >= 9) begin
                            done <= 1;
                            if (bitcounter == 10)
                                rdy <= 1;
                        end                                               
                    end
                end
            end
        end
    end 

    //state machine    
    always @ (posedge clk or negedge rstn) 
    begin
        if (!rstn) begin
            load <=0; 
            shift <=0; 
            clear <=0; 
            TxD <=1; 
            nextstate <=0;                     
        end
        else begin        
            case (state)
                IDLE: begin 
                     if (transmit_delay) begin 
                         nextstate <= TX; 
                         load <=1; 
                         shift <=0; 
                         clear <=0; 
                     end 
                     else begin 
                         nextstate <= IDLE; 
                         TxD <= 1;     
                     end
                   end
                TX: begin  
                     if (bitcounter >=10) begin 
                         nextstate <= IDLE; 
                         clear <=1;     
                     end 
                     else begin  
                         nextstate <= TX; 
                         TxD <= rightshiftreg[0]; 
                         shift <=1; 
                     end
                   end
                 default: nextstate <= IDLE;                      
            endcase
        end
    end
endmodule

