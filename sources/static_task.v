module static_task;
reg [3:0] result;
initial begin
    // expecting
    // 3 The value of count is  0
    #3 check_counter(1'b1, result);
    $display($realtime,,"The value of count is %d", result);
    //19 The value of count is  3
    #6 check_counter(1'b0, result);
    $display($realtime,,"The value of count is %d", result);
    //35 The value of count is  6
    #6 check_counter(1'b0, result);
    $display($realtime,,"The value of count is %d", result);
end

// task definition starts from here
task check_counter;
    input reset;
    output reg [3:0] count;
    // the body of the task
    begin
        if (reset) count = 0;
        else begin
            #2 count = count + 1;
            #3 count = count + 1;
            #5 count = count + 1;
        end
    end
endtask
endmodule
