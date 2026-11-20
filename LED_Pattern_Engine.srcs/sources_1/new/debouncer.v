`timescale 1ns / 1ps

module debouncer #(
    parameter integer G_CLK_FREQ = 100_000_000,
    parameter integer G_AMOUNT_OF_MS = 20
) (
    input wire clk_i,
    input wire rst_n_i,

    input wire btn_i,

    output reg btn_o
);

    localparam rate = (G_CLK_FREQ / 1000) * G_AMOUNT_OF_MS; 

    reg start_cnt;
    reg [$clog2(rate) - 1:0] cnt;

    always @(posedge clk_i) begin
        if (!rst_n_i) begin
            btn_o <= 0;
        end else begin
            if(!start_cnt) begin

                if(btn_i) begin
                    start_cnt <= 1;
                end

            end else begin
                
                if(!btn_i) begin
                    start_cnt <= 0;
                    cnt <= 0;
                    btn_o <= 0;
                end else begin
                    cnt <= cnt + 1;
                    if(cnt > rate - 1) begin
                        btn_o <= 1;
                    end
                end

            end
        end
    end
endmodule