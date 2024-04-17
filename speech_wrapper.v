module speech_wrapper (
    input clk,
    input rst,
    input phoneme_speech_busy,
    input phoneme_speech_finish,
    input speech_synthesize_write_H,
    input speech_synthesize_read_H,
    input [15:0] datain,
    output reg [7:0] phoneme_sel,
    output reg start_phoneme_output,
    output [15:0] dataout,
    output [1:0] state
);

parameter IDLE = 2'd0;
parameter START = 2'd1;
parameter FINISH = 2'd3;
parameter WAIT = 2'd2;

reg [1:0] currentState;
reg [1:0] nextState;
reg [7:0] phoneme_sel_reg;
// reg start;
// reg deactivate_start;

always@(*) begin
    case(currentState) 
    IDLE: begin
        start_phoneme_output = 1'b0;
        // deactivate_start = 1'b0;
        if (speech_synthesize_write_H)
            nextState = START;
        else
            nextState = IDLE;
    end
    START: begin
        start_phoneme_output = 1'b1;
        nextState = WAIT;
        // deactivate_start = 1'b1;
    end
    WAIT: begin
        start_phoneme_output = 1'b0;
        if (phoneme_speech_busy)
            nextState = FINISH;
        else
            nextState = WAIT;
    end
    FINISH: begin
        start_phoneme_output = 1'b0;
        // deactivate_start = 1'b1;
        if (~phoneme_speech_busy)
            nextState = IDLE;
        else 
            nextState = FINISH;
    end
    default: begin
        start_phoneme_output = 1'b0;
        nextState = IDLE;
    end
    endcase
end

assign dataout = speech_synthesize_read_H ? {15'b0, phoneme_speech_busy} : 16'bz;

always@(posedge clk) begin
    currentState <= nextState;
    if (speech_synthesize_write_H)
        phoneme_sel_reg <= datain[7:0];
end

assign phoneme_sel = phoneme_sel_reg;

assign state = currentState;
endmodule