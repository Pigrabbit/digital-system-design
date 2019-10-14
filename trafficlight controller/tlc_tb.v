`timescale 1ns / 1ps

module tlc_tb();
    
    reg MCLK, RESET, FS, HS;
    wire [7:0] LED;
    integer H_is_correct, F_is_correct, HF_is_correct;
    
    tlc_top my_tlc_top (
        .MCLK       (MCLK),
        .RESET      (RESET),
        .FS         (FS),
        .HS         (HS),
        .LED        (LED)
    );
    
    parameter PERIOD = 1;
    
    initial begin
        MCLK = 1'b0;
        forever #PERIOD MCLK = !MCLK;
    end
 
    initial begin
        RESET = 1'b1;        
        #(2*PERIOD) RESET = 1'b0;    
    end
 
    initial begin:stimuli
        FS = 1'b0;
        HS = 1'b0;  

        #(5*PERIOD)
            FS = 1'b1;
            HS = 1'b0;

        #(6*PERIOD)
            FS = 1'b0;
            HS = 1'b0;

        #(4*PERIOD)
            FS = 1'b0;
            HS = 1'b1;
          
        #(6*PERIOD)
            FS = 1'b0;
            HS = 1'b0;
           
        #(6*PERIOD)
            FS = 1'b1;
            HS = 1'b1;
          
        #(6*PERIOD)
            FS = 1'b1;
            HS = 1'b0;

        #(4*PERIOD)
            FS = 1'b0;
            HS = 1'b0;
           
        #(10*PERIOD)
            $finish;
    end
    
    initial begin
        F_is_correct = 1;
        H_is_correct = 1;
        HF_is_correct = 1;

    //// Output Check for F=1
        #(8*PERIOD) 
            $display("Car at F");
            if (LED[6:0] == 7'b0100100) begin
                $display("S1 %0t", $time);
            end
            else begin
                $display("S1 fail %0t", $time);
                F_is_correct = 0;
            end
        #(2*PERIOD)
            if (LED[6:0] == 7'b1000001) begin
                $display("S3 %0t", $time);
            end
            else begin
                $display("S3 fail %0t", $time);
                F_is_correct = 0;
            end        
        #(2*PERIOD)
            if (LED[6:0] == 7'b1000010) begin
                $display("S5 %0t", $time);
            end
            else begin
                $display("S5 fail %0t", $time);
                F_is_correct = 0;
            end
        #(2*PERIOD)
            if (LED[6:0] == 7'b0001100) begin
                $display("S7 %0t", $time);
            end
            else begin
                $display("S7 fail %0t", $time);
                F_is_correct = 0;
            end
 
    //// Output Check for H=1   
        #(4*PERIOD) 
            $display("Car at H");
            if (LED[6:0] == 7'b0100100) begin
                $display("S1 %0t", $time);
            end
            else begin
                $display("S1 fail %0t", $time);
                H_is_correct = 0;
            end
        #(2*PERIOD)
            if (LED[6:0] == 7'b0010100) begin
                $display("S2 %0t", $time);
            end
            else begin
                $display("S2 fail %0t", $time);
                H_is_correct = 0;
            end
        #(2*PERIOD)
            if (LED[6:0] == 7'b0100100) begin
                $display("S4 %0t", $time);
            end
            else begin
                $display("S4 fail %0t", $time);
                H_is_correct = 0;
            end
        #(2*PERIOD)
            if (LED[6:0] == 7'b0001100) begin
                $display("S6 %0t", $time);
            end
            else begin
                $display("S6 fail %0t", $time);
                H_is_correct = 0;
            end
 
    //// Output Check for H, F = 1
        #(6*PERIOD) 
            $display("Car at H and F");
            if (LED[6:0] == 7'b0100100) begin
                $display("S1 %0t", $time);
            end
            else begin
                $display("S1 fail %0t", $time);
                HF_is_correct = 0;
            end
        #(2*PERIOD)
            if(LED[6:0] == 7'b0010100) begin
                $display("S2 %0t", $time);
            end
            else begin
                $display("S2 fail %0t", $time);
                HF_is_correct = 0;
            end
        #(2*PERIOD)
            if(LED[6:0] == 7'b0100100) begin
                $display("S4 %0t", $time);
            end
            else begin
                $display("S4 fail %0t", $time);
                HF_is_correct = 0;
            end
        #(2*PERIOD)
            if(LED[6:0] == 7'b1000001) begin
               $display("S3 %0t", $time);
            end
            else begin
               $display("S3 fail %0t", $time);
               HF_is_correct = 0;
            end         
        #(2*PERIOD)
            if (LED[6:0] == 7'b1000010) begin
                $display("S5 %0t", $time);
            end
            else begin
                $display("S5 fail %0t", $time);
                HF_is_correct = 0;
            end
        #(2*PERIOD)
            if (LED[6:0] == 7'b0001100) begin
                $display("S7 %0t", $time);
            end
            else begin
                $display("S7 fail %0t", $time);
                HF_is_correct = 0;
            end
              
        #(4*PERIOD)
            if (F_is_correct & H_is_correct & HF_is_correct) begin
                $display("[Result] All cars passed w/o crashing. Good job!");
            end
            else begin
                $display("[Result] Cars crashed :(, try again.");
            end
    end
    
endmodule
