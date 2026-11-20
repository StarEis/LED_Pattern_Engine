`default_nettype none

module clk_enable_gen #(
  parameter G_CLK_FREQ = 125_000_000
) (
  input wire clk_i,
  input wire rst_n_i,

  input wire [1:0] step_rate_i,

  input wire start_i,

  output reg enable_o
);

  // G_CLK_FREQ / DESIRED_FREQ
  // The desired frequencies are: 1hz, 2hz, 4hz and 10hz
  localparam C_1HZ = G_CLK_FREQ / 1;
  localparam C_2HZ = G_CLK_FREQ / 2;
  localparam C_4HZ = G_CLK_FREQ / 4;
  localparam C_10HZ = G_CLK_FREQ / 10;

  localparam C_CNT_WIDTH = $clog2(C_1HZ);

  reg [C_CNT_WIDTH - 1:0] cnt_s;

  reg [1:0] current_rate_s;

  reg start_s;

  always @(posedge clk_i) begin
    if(!rst_n_i) begin
      cnt_s <= 0;
      enable_o <= 0;  
      current_rate_s <= 2'b00;   
      start_s <= 0; 
    end else begin

      enable_o <= 0;

      if(start_i) begin
        start_s <= ~start_s;
      end
      
      if(start_s) begin

        cnt_s <= cnt_s + 1;
        current_rate_s <= step_rate_i;

        if(current_rate_s != step_rate_i) begin
          cnt_s <= 0;
        end else begin 
          case (current_rate_s)
            2'b00:  begin   
              if(cnt_s == C_1HZ - 1) begin 
                cnt_s <= 0; 
                enable_o <= 1; 
              end
            end
            
            2'b01:  begin   
              if(cnt_s == C_2HZ - 1) begin 
                cnt_s <= 0; 
                enable_o <= 1; 
              end
            end
            
            2'b10:  begin   
              if(cnt_s == C_4HZ - 1) begin 
                cnt_s <= 0; 
                enable_o <= 1; 
              end
            end
            
            2'b11:  begin   
              if(cnt_s == C_10HZ - 1) begin 
                cnt_s <= 0; 
                enable_o <= 1; 
              end
            end
          endcase
          
        end
      end else begin
        cnt_s <= 0;
      end

    end

  end


endmodule

`default_nettype wire