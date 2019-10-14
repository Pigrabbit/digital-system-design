module tlc_top (
    input        MCLK,
    input        RESET,
    input        FS,
    input        HS,
    output [7:0] LED
    );

    wire       CLOCK;
    wire       RESET_OUT;
    wire [7:0] LED_TEMP;

    wire       FLEFT;
    wire       FRED;
    wire       FYELLOW;
    wire       HGREEN;
    wire       HLEFT;
    wire       HRED;
    wire       HYELLOW;

    wire       HS_OUT;
    wire       FS_OUT;
  
    data_reg u_data_reg (
        .MCLK      (MCLK     ),
        .RESET     (RESET    ),
        .FLEFT     (FLEFT    ),
        .FS_IN     (FS       ),
        .HLEFT     (HLEFT    ),
        .HS_IN     (HS       ),

        .FS_OUT    (FS_OUT   ),
        .HS_OUT    (HS_OUT   )  
    );

    tlc_fsm u_tlc_fsm (
        .CLOCK     (MCLK     ), 
        .RESET     (RESET),
        .FS        (FS_OUT   ),
        .HS        (HS_OUT   ),
                             
        .FLEFT     (FLEFT    ), 
        .FRED      (FRED     ),
        .FYELLOW   (FYELLOW  ),
        .HGREEN    (HGREEN   ),
        .HLEFT     (HLEFT    ),
        .HRED      (HRED     ),
        .HYELLOW   (HYELLOW  )
    );

    output_logic u_output_logic (
        .CLOCK     (MCLK     ),
        .FLEFT     (FLEFT    ),
        .FRED      (FRED     ),
        .FYELLOW   (FYELLOW  ),
        .HGREEN    (HGREEN   ),
        .HLEFT     (HLEFT    ),
        .HRED      (HRED     ),
        .HYELLOW   (HYELLOW  ),
                             
        .LED       (LED_TEMP ) 
    );

    assign LED = LED_TEMP;

endmodule
