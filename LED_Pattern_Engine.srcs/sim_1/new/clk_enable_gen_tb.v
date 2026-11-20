`timescale 1ns / 1ps

module clk_enable_gen_tb(

    );


localparam C_CLK_FREQ = 1000; // hz
localparam C_CLK_PERIOD = 1_000_000_000 / C_CLK_FREQ; // ns

reg clk_s;
reg rst_n_s;
reg [1:0] step_rate_s;
reg start_s;
wire enable_s;



clk_enable_gen #(.G_CLK_FREQ(C_CLK_FREQ)) u_dut (
  .clk_i(clk_s),
  .rst_n_i(rst_n_s),
  .step_rate_i(step_rate_s),
  .start_i(start_s),

  .enable_o(enable_s)
);


reg [31:0] cnt;
task test_run; 
  input integer exp;

  begin
    cnt = 0;
    repeat (C_CLK_FREQ) begin
      @(posedge clk_s); 
      if(enable_s == 1) begin
        cnt = cnt + 1;
      end
    end

    if(cnt === exp) begin
      $display("pass");
    end else begin
      $display("fail");
    end
  end
  
endtask

initial clk_s = 1'b0;
always #(C_CLK_PERIOD / 2) clk_s = ~clk_s;

initial begin
  rst_n_s = 0;
  step_rate_s = 2'b00;
  start_s = 0;


  repeat(2) @(posedge clk_s);
  #1 rst_n_s = 1;
  repeat(2) @(posedge clk_s);
  #1 start_s = 1;
  repeat(1) @(posedge clk_s);
  start_s = 0;

  test_run(1);

  step_rate_s = 2'b01;
  repeat(1) @(posedge clk_s);
  test_run(2);

  step_rate_s = 2'b10; 
  repeat(1) @(posedge clk_s);
  test_run(4);

  step_rate_s = 2'b11; 
  repeat(1) @(posedge clk_s);
  test_run(10);

  $finish;
end

endmodule
