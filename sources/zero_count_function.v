module zero_count_function(data, out);
    input [7:0] data;
    output reg [3:0] out;

    always @(data)
        out = count_0s_in_byte(data);

    function [3:0] count_0s_in_byte(input [7:0] data);
        integer i;
        
        begin
            count_0s_in_byte = 0;
            for (i = 0; i < 8; i = i + 1)
                if(data[i] == 0) count_0s_in_byte = count_0s_in_byte + ~data[i];
        end
    endfunction
endmodule
