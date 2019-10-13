`timescale 1ns/1ps;
module handshaking_wait;
    reg [7:0] data, data_output;
    reg ready = 1'b0, ack = 1'b0;
    integer seed =5;

    initial #400 finish;

    always begin: source
        #5 data <= $random(seed) % 13;
        $display("The source data is %d", data);
        #2 ready <= 1'b1;
        
        wait(ack);
        #12 ready <= 1'b0;
        seed = seed + 3;
    end

    always begin: destination
        wait(ready);
        #5 ack <= 1'b1;
        @(negedge ready) data_output <= data;
        $display("The output data is %d", data_output);
        #3 ack <= 0;
    end
endmodule