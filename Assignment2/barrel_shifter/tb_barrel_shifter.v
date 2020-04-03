`timescale 1ns/1ps
module tb_barrel_shifter;
    parameter WIDTH = 8;
    parameter N = 16;
    parameter K = 4;

    parameter TEST_CASE = 128'h000102030405060708090a0b0c0d0e0f;

    parameter CLK_CYCLE = 5;

    reg clk;
    reg [N * WIDTH - 1:0] in;
    reg [K - 1:0] sel;
    wire [N * WIDTH - 1:0] out;

    always #(0.5 * CLK_CYCLE) clk = ~ clk;

    barrel_shifter #(
        .N(N),
        .K(K), 
        .WIDTH(WIDTH)
    )
    shifter_dut
    (
        .clk(clk), 
        .in(in),
        .sel(sel),
        .out(out)
    );

    initial 
    begin : test
        integer i;
        clk = 1;

        #(3.5 * CLK_CYCLE) 
        in = TEST_CASE;
        #(0.1 * CLK_CYCLE)
        for(i = 0; i < 2 ** K; i = i + 1)
        begin
            sel = i;
            #(CLK_CYCLE);
        end

        #(2 * K * CLK_CYCLE)
        $finish;
    end

endmodule
