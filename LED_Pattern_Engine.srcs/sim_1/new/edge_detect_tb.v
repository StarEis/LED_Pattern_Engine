`timescale 1ns / 1ps
`default_nettype none

module edge_detect_tb(

    );

localparam integer C_CLK_FREQ = 100; // hz
localparam integer C_CLK_PERIOD = 1_000_000_000 / C_CLK_FREQ; // ns

reg clk_s;
reg rst_n_s;
reg signal_s;

wire posedge_s;
wire negedge_s;

edge_detect u_dut (
  .clk_i(clk_s),
  .rst_n_i(rst_n_s),
  .signal_i(signal_s),
  .posedge_o(posedge_s),
  .negedge_o(negedge_s)

);

task check;
  input signal_i;
  begin
    if(signal_i == 1'b1) begin
      $display("Pass");
    end else begin
      $display("Fail");
    end
  end

endtask 

initial clk_s = 1'b0;
always #(C_CLK_PERIOD / 2) clk_s = ~clk_s;

initial begin
  rst_n_s = 1'b0;
  signal_s = 1'b0;
  @(posedge clk_s);
  #1 rst_n_s = 1;
  @(posedge clk_s);

  signal_s = 1;
  @(posedge clk_s);
  check(posedge_s);

  repeat (5) @(posedge clk_s);

  signal_s = 0;
  @(posedge clk_s);
  check(negedge_s);

  repeat (5) @(posedge clk_s);

  $finish;

  
end
    
endmodule

`default_nettype wire
