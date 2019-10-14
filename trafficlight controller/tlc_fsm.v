module tlc_fsm (
    input       CLOCK,
    input       RESET,
    input       FS,
    input       HS,

    output reg  FLEFT,
    output reg  FRED,
    output reg  FYELLOW,
    output reg  HGREEN,
    output reg  HLEFT,
    output reg  HRED,
    output reg  HYELLOW
    );

    reg [2:0] c_state;
    reg [2:0] n_state;

    // initial begin
    //     c_state = 3'b000;
    //     n_state = 3'b000;
    // end

    initial begin
        FLEFT = 1'b0; FRED = 1'b0; FYELLOW = 1'b0;
        HGREEN = 1'b0; HLEFT = 1'b0; HRED = 1'b0; HYELLOW = 1'b0;
    end

    // states: 3-bit
    // S0: HGREEN & FRED  S1: HYELLOW & FRED
    // S2: HLEFT & FRED   S3: HRED & FLEFT
    // S4: HYELLOW & FRED S5: HRED & FYELLOW
    // S6: HGREEN & FRED  S7: HGREEN & FRED

    always @(posedge CLOCK, posedge RESET) begin
        if(RESET == 1'b1) begin
            c_state <= 3'b000;
        end
        else begin
            c_state <= n_state;
        end
    end

///////////////////////////////////////////////////////////
//// TODO: insert your codes about (n_state)
    always @(*) begin
        case(c_state)
            // S0 HGREEN & FRED
            3'b000:
                if (HS || FS) n_state <= 3'b001;
                else n_state <= 3'b000;
            // S1 HYELLOW & FRED
            3'b001:
                if (HS) n_state <= 3'b010;
                else if (!HS && FS) n_state <= 3'b011;
            // S2 HLEFT & FRED
            3'b010:
                if (HS) n_state <= 3'b100;
            // S3 HRED & FLEFT
            3'b011:
                if (FS) n_state <= 3'b101;
            // S4 HYELLOW & FRED
            3'b100:
                if (!FS) n_state <= 3'b110;
                else if (FS) n_state <= 3'b011;
            // S5 HRED & FYELLOW
            3'b101: n_state <= 3'b111;
            // S6 HGREEN & FRED
            3'b110: n_state <= 3'b000;
            // S7 HGREEN & FRED
            3'b111: n_state <= 3'b000;
        endcase
    end
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
//// TODO: insert your codes about (output)
    always @(*) begin
        case(c_state)
            3'b000: 
                begin
                    HGREEN = 1'b1; FRED = 1'b1;
                    HRED = 1'b0; HYELLOW = 1'b0; HLEFT = 1'b0;
                    FYELLOW = 1'b0; FLEFT = 1'b0;
                end
            3'b001: 
                begin 
                    HYELLOW = 1'b1; FRED = 1'b1;
                    HRED = 1'b0; HLEFT = 1'b0; HGREEN = 1'b0;
                    FLEFT = 1'b0; FYELLOW = 1'b0;
                end
            3'b010: 
                begin 
                    HLEFT = 1'b1; FRED = 1'b1;
                    HGREEN = 1'b0; HRED = 1'b0; HYELLOW = 1'b0;
                    FLEFT = 1'b0; FYELLOW = 1'b0;
                end
            3'b011: 
                begin 
                    HRED = 1'b1; FLEFT = 1'b1;
                    HYELLOW = 1'b0; HLEFT = 1'b0; HGREEN = 1'b0;
                    FRED = 1'b0; FYELLOW = 1'b0;
                end
            3'b100: 
                begin 
                    HYELLOW = 1'b1; FRED = 1'b1;
                    HRED = 1'b0; HLEFT =1'b0; HGREEN = 1'b0;
                    FYELLOW = 1'b0; FLEFT = 1'b0;
                end
            3'b101: 
                begin 
                    HRED = 1'b1; FYELLOW = 1'b1;
                    HYELLOW = 1'b0; HLEFT = 1'b0; HGREEN = 1'b0;
                    FRED = 1'b0; FLEFT = 1'b0;
                end
            3'b110: 
                begin
                    HGREEN = 1'b1; FRED = 1'b1;
                    HRED = 1'b0; HYELLOW = 1'b0; HLEFT = 1'b0;
                    FYELLOW = 1'b0; FLEFT = 1'b0;
                end
            3'b111: 
                begin
                    HGREEN = 1'b1; FRED = 1'b1;
                    HRED = 1'b0; HYELLOW = 1'b0; HLEFT = 1'b0;
                    FYELLOW = 1'b0; FLEFT = 1'b0;
                end           
        endcase
    end
///////////////////////////////////////////////////////////

endmodule
