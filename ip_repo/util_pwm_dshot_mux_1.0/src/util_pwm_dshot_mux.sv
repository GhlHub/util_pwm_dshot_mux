module util_pwm_dshot_mux #(
    parameter bit DSHOT_OEB_ACTIVE_LOW = 1'b1,
    parameter bit DIR_A_TO_B           = 1'b1,
    parameter bit DIR_B_TO_A           = 1'b0
) (
    input  logic clk,
    input  logic rst,
    input  logic select_dshot,

    output logic pwm_in,

    output logic dshot_in,
    input  logic dshot_out,
    input  logic dshot_oeb,

    inout  wire  pad_a,
    output wire  pad_dir
);

    // TURN states insert the required one-clock gap between changing DIR
    // and enabling or disabling the FPGA output driver.
    typedef enum logic [2:0] {
        STATE_PWM_RX   = 3'd0,
        STATE_DSHOT_RX = 3'd1,
        STATE_TX_TURN  = 3'd2,
        STATE_DSHOT_TX = 3'd3,
        STATE_RX_TURN  = 3'd4
    } state_t;

    state_t state_q = STATE_PWM_RX;
    state_t state_d;

    logic pad_i;
    logic pad_o;
    logic pad_t;
    logic dir_o;
    logic dshot_tx_req;

    assign dshot_tx_req = DSHOT_OEB_ACTIVE_LOW ? ~dshot_oeb : dshot_oeb;

    always_comb begin
        state_d = state_q;

        unique case (state_q)
            STATE_PWM_RX: begin
                if (select_dshot) begin
                    if (dshot_tx_req) begin
                        state_d = STATE_TX_TURN;
                    end else begin
                        state_d = STATE_DSHOT_RX;
                    end
                end
            end

            STATE_DSHOT_RX: begin
                if (!select_dshot) begin
                    state_d = STATE_PWM_RX;
                end else if (dshot_tx_req) begin
                    state_d = STATE_TX_TURN;
                end
            end

            STATE_TX_TURN: begin
                if (!select_dshot) begin
                    state_d = STATE_PWM_RX;
                end else if (dshot_tx_req) begin
                    state_d = STATE_DSHOT_TX;
                end else begin
                    state_d = STATE_DSHOT_RX;
                end
            end

            STATE_DSHOT_TX: begin
                if (!select_dshot || !dshot_tx_req) begin
                    state_d = STATE_RX_TURN;
                end
            end

            STATE_RX_TURN: begin
                if (!select_dshot) begin
                    state_d = STATE_PWM_RX;
                end else if (dshot_tx_req) begin
                    state_d = STATE_TX_TURN;
                end else begin
                    state_d = STATE_DSHOT_RX;
                end
            end

            default: begin
                state_d = STATE_PWM_RX;
            end
        endcase
    end

    always_comb begin
        pad_o  = dshot_out;
        pad_t  = 1'b1;
        dir_o  = DIR_B_TO_A;
        pwm_in = 1'b0;
        dshot_in = 1'b0;

        unique case (state_q)
            STATE_PWM_RX: begin
                pwm_in = pad_i;
            end

            STATE_DSHOT_RX: begin
                dshot_in = pad_i;
            end

            STATE_TX_TURN: begin
                dir_o = DIR_A_TO_B;
            end

            STATE_DSHOT_TX: begin
                dir_o = DIR_A_TO_B;
                pad_t = 1'b0;
                dshot_in = pad_i;
            end

            STATE_RX_TURN: begin
                dir_o = DIR_A_TO_B;
                dshot_in = pad_i;
            end

            default: begin
                pwm_in = pad_i;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state_q <= STATE_PWM_RX;
        end else begin
            state_q <= state_d;
        end
    end

    IOBUFT data_iobuf_inst (
        .I(pad_o),
        .O(pad_i),
        .T(pad_t),
        .IO(pad_a)
    );

    OBUF dir_obuf_inst (
        .I(dir_o),
        .O(pad_dir)
    );

endmodule
