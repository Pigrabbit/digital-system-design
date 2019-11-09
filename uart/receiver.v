// You could design the receiver module freely, But you need to follow the rules.
// Rule 1. Do not modify the input/output ports
// Rule 2. "valid", "done", "data" ports should do correct actions. Please refer to the "Lab8_uart" PPT



`timescale 1ns / 1ps

module receiver 
#(
    parameter baud_rate_count= 108
)
( 
    input clk,
    input RxD,
    input rstn,
    input receive,
    input rdy,           
    input full,
    output reg valid,       
    output reg done,    
    output reg [7:0] data
);
    reg [1:0] state;
    reg  next_state;
    reg [3:0] bit_counter;
    reg [30:0] counter;
    reg flag;
    
    localparam IDLE = 0;
    localparam RX = 1;
        
    always @ (posedge clk or negedge rstn) begin
        if (!rstn) begin
            counter <={31{1'b0}}; 
            flag <= 1'b0;
        end
        else if(receive) begin
            if ( counter >= baud_rate_count) begin
                counter <= 0;
                flag <= 1;                    
            end
            else begin
                counter <= counter + 1;
                flag <= 0;
            end
        end
        else begin
            counter <= 0;
            flag <= 0;
        end
    end

	
/************* TODO************/ 
// Task 1. Serial -> parallel data
//-----------------------------    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin 
            
        end

        else begin
            
			
        end
    end
    
/************* TODO************/ 
// Task 2. State machine.
//-----------------------------  
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            
        end
        else begin        
            case(state)
                IDLE: begin 
                    
				end
                RX: begin
                       
                    end                
            endcase
        end
    end
endmodule
