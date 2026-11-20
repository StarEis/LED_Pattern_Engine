`default_nettype none

module edge_detect (
  input wire clk_i,
  input wire rst_n_i,

  input wire signal_i,

  output reg posedge_o,
  output reg negedge_o
);

reg previous_signal_s;

always @(posedge clk_i) begin
  if (!rst_n_i) begin
    posedge_o <= 0;
    negedge_o <= 0;
    previous_signal_s <= 0;
  end else begin
    posedge_o <= 0;
    negedge_o <= 0;

    previous_signal_s <= signal_i;

    if(previous_signal_s == 1'b0 && signal_i == 1'b1) begin
      posedge_o <= 1;
    end else if (previous_signal_s == 1'b1 && signal_i == 1'b0) begin
      negedge_o <= 1;
    end
  end
end
  
endmodule

`default_nettype wire