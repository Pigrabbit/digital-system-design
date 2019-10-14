module data_reg (
    input  MCLK,
    input  RESET,
    input  FLEFT,
    input  FS_IN,
    input  HLEFT,
    input  HS_IN,

    output FS_OUT,
    output HS_OUT
    );

    reg  fs_internal;
    reg  hs_internal;
    reg  fs_catch;
    reg  hs_catch;

    always @(posedge MCLK, posedge RESET) begin
        if (RESET) begin
            fs_catch <= 1'b0;
            hs_catch <= 1'b0;
        end
        else begin
            fs_catch <= fs_internal;
            hs_catch <= hs_internal;
        end
    end
  
    always @(*) begin
        if ((FS_IN == 1'b0) && (FLEFT == 1'b0)) begin    
            fs_internal = fs_catch;
        end
        else if ((FS_IN == 1'b1) && (FLEFT == 1'b0)) begin
            fs_internal = 1'b1;
        end
        else if ((FS_IN == 1'b0) && (FLEFT == 1'b1)) begin
            fs_internal = 1'b0;
        end
        else begin
            fs_internal = 1'b0;
        end
    end
  
    always @(*) begin
        if ((HS_IN == 1'b0) && (HLEFT == 1'b0)) begin
            hs_internal = hs_catch;
        end
        else if ((HS_IN == 1'b1) && (HLEFT == 1'b0)) begin  
            hs_internal = 1'b1;
        end
        else if ((HS_IN == 1'b0) && (HLEFT == 1'b1)) begin 
            hs_internal = 1'b0;
        end
        else begin
            hs_internal = 1'b0;
        end
    end
  
    assign FS_OUT = fs_catch;
    assign HS_OUT = hs_catch;

endmodule

