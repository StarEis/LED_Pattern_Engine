module pattern_gen_tb(

  );

/*
module pattern_gen (
  input wire clk_i,
  input wire rst_n_i,

  input wire step_i,

  input wire up_or_down_i,
  input wire halve_brightness_i,
  input wire change_pattern_i,

  output reg [3:0] pattern_o
);
*/
parameter integer C_CLK_FREQ = 100_000; // hz
parameter integer C_CLK_PERIOD = 1_000_000_000 / C_CLK_FREQ; // ns
parameter integer C_PWM_FREQ = 6_250; // hz

reg clk_s;
reg rst_n_s;
reg step_s;

reg up_or_down_s;
reg halve_brightness_s;
reg change_pattern_s;

wire [3:0] pattern_s;

initial clk_s = 0;
always #(C_CLK_PERIOD / 2) clk_s = ~clk_s;

task test;
  begin
    step_s = 1'b1;
    repeat(17) @(posedge clk_s);
    step_s = 1'b0;

    change_pattern_s = 1'b1;
    @(posedge clk_s);
    change_pattern_s = 0;
    @(posedge clk_s);
  end
endtask

pattern_gen #(.G_CLK_FREQ(C_CLK_FREQ), .G_PWM_FREQ(C_PWM_FREQ))u_dut (
  .clk_i(clk_s),
  .rst_n_i(rst_n_s),
  .step_i(step_s),
  .up_or_down_i(up_or_down_s),
  .halve_brightness_i(halve_brightness_s),
  .change_pattern_i(change_pattern_s),
  .pattern_o(pattern_s)
);

initial begin
  rst_n_s = 1'b0;
  step_s = 1'b0;
  up_or_down_s = 1'b0;
  halve_brightness_s = 0;
  change_pattern_s = 0;
  @(posedge clk_s);
  #1 rst_n_s = 1;
  @(posedge clk_s); 

  repeat (4) test();
  
  up_or_down_s = 1'b1;
  @(posedge clk_s);

  repeat (4) test();

  up_or_down_s = 1'b0;
  halve_brightness_s = 1'b1;
  @(posedge clk_s);

  repeat (4) test();
  
  $finish;
  
end


endmodule
