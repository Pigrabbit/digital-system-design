`timescale 1ns / 1ps

module transmit_debouncing 
#(
    parameter threshold = 20
)//100000)// set parameter thresehold to guage how long button pressed
(
    input clk, //clock signal
    input btn1, //input buttons for transmit and reset
    input rstn,
    input t_done,
    output reg transmit //transmit signal
);
    
    reg button_ff1; //button flip-flop for synchronization. Initialize it to 0
    reg button_ff2; //button flip-flop for synchronization. Initialize it to 0
    reg [30:0]count; //20 bits count for increment & decrement when button is pressed or released. Initialize it to 0 
    
    
    // First use two flip-flops to synchronize the button signal the "clk" clock domain
    
    always @(posedge clk or negedge rstn)begin
        if (!rstn) begin
            button_ff1 <= 1'b0;
            button_ff2 <= 1'b0;            
        end
        else begin
            button_ff1 <= btn1;
            button_ff2 <= button_ff1;
        end
    end
    
    // When the push-button is pushed or released, we increment or decrement the counter
    // The counter has to reach threshold before we decide that the push-button state has changed
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            count <= {31{1'b0}};
            transmit <= 1'b0;
        end
        else begin
            if(t_done) begin
                count <= 0;
                transmit <= 0; 
            end
            else begin
                if (button_ff2) begin//if button_ff2 is 1 
                    if (~&count)//if it isn't at the count limit. Make sure won't count up at the limit. First AND all count and then not the AND
                        count <= count+1; // when btn pressed, count up
                end 
                else begin
                    if (|count)//if count has at least 1 in it. Make sure no subtraction when count is 0 
                        count <= count-1; //when btn relesed, count down
                end
                
                if (count > threshold)//if the count is greater the threshold 
                    transmit <= 1; //debounced signal is 1
                else
                    transmit <= 0; //debounced signal is 0
            end        
        end 

    end
endmodule