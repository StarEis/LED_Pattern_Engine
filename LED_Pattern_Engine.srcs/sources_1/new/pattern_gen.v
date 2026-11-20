`default_nettype none

module pattern_gen #(
  parameter integer G_CLK_FREQ = 125_000_000, //hz
  parameter integer G_PWM_FREQ = 10000
) (
  input wire clk_i,
  input wire rst_n_i,

  input wire step_i,

  input wire up_or_down_i,
  input wire halve_brightness_i,
  input wire change_pattern_i,
  input wire reset_pattern_i,

  output wire [3:0] pattern_o
);

localparam integer C_CNT_LENGTH = $clog2(G_CLK_FREQ / G_PWM_FREQ);

reg [3:0] pattern_s;

reg [1:0] current_pattern_s;
reg [3:0] state_s;

always @(posedge clk_i) begin
  if (!rst_n_i) begin
    current_pattern_s <= 2'b00;
    state_s <= 4'b0000;
    pattern_s <= 4'b0000;
  end else begin
    if(step_i) begin
      if(!up_or_down_i) begin
        state_s <= state_s + 1;
      end else begin
        state_s <= state_s - 1;
      end
    end

    if(change_pattern_i) begin
      current_pattern_s <= current_pattern_s + 1;
      state_s <= 4'b0000;
    end

    if(reset_pattern_i) begin
      state_s <= 4'b0000;
    end

    case (current_pattern_s)
      2'b00: begin  // binary counter 
        pattern_s <= state_s;
      end 

      2'b01: begin // gray counter
        pattern_s <= state_s ^ (state_s >> 1);
      end 

      2'b10: begin // bouncing light
        pattern_s[3] <= state_s[1] & state_s[0];
        pattern_s[2] <= ~state_s[0] & (state_s[2] ^ state_s[1]);
        pattern_s[1] <= ~state_s[1] & state_s[0];
        pattern_s[0] <= ~(state_s[0] | state_s[1] | state_s[2]);

        if(step_i) begin
          if((state_s == 4'b0101) & !up_or_down_i) begin
            state_s <= 4'b0000;
          end else if ((state_s == 4'b0000) & up_or_down_i) begin
            state_s <= 4'b0101;
          end
        end
      end 

      2'b11: begin // johnson counter
        pattern_s[3] <= state_s[2];
        pattern_s[2] <= state_s[2] ^ (state_s[1] & state_s[0]);
        pattern_s[1] <= state_s[2] ^ state_s[1];
        pattern_s[0] <= state_s[2] ^ (state_s[1] | state_s[0]);

        if(step_i) begin
          if((state_s == 4'b0111) & !up_or_down_i) begin
            state_s <= 4'b0000;
          end else if ((state_s == 4'b0000) & up_or_down_i) begin
            state_s <= 4'b0111;
          end
        end
      end
    endcase
  end
end

reg [C_CNT_LENGTH - 1:0] cnt_s;
wire [3:0] mask_s;

always @(posedge clk_i) begin
  if (!rst_n_i) begin
    cnt_s <= 0;
  end else begin
    if(halve_brightness_i) begin
      cnt_s <= cnt_s + 1;
    end else begin
      cnt_s <= 0;
    end
  end
end

assign mask_s = halve_brightness_i ? {4 {cnt_s[C_CNT_LENGTH - 1]}} : 4'b1111;

assign pattern_o = pattern_s & mask_s;

endmodule

`default_nettype wire