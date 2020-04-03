`timescale 1ns/1ps
/*
 * @Author: Yihao Wang
 * @Date: 2020-03-13 19:08:38
 * @LastEditTime: 2020-04-03 15:22:18
 * @LastEditors: Please set LastEditors
 * @Description: Testbench for pipelined barrel shifter
 * @FilePath: /undefined/Users/yihaowang/Desktop/ee599/EE599_YihaoWang_7410178057/Assignment2/barrel_shifter/tb_barrel_shifter.v
 */
module tb_barrel_shifter;
    parameter WIDTH = 8;
    parameter N = 16;
    parameter K = 4;

    // Using a fixed input test patterns
    parameter TEST_CASE = 128'h000102030405060708090a0b0c0d0e0f;

    parameter CLK_CYCLE = 5; // cycle time

    reg clk;
    reg [N * WIDTH - 1:0] in;
    reg [K - 1:0] sel; // shift control signal
    wire [N * WIDTH - 1:0] out;

    always #(0.5 * CLK_CYCLE) clk = ~ clk;

    // Instantiation
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
        
        // change sel value at loop cycle
        for(i = 0; i < 2 ** K; i = i + 1)
        begin
            sel = i;
            #(CLK_CYCLE);
        end

        // wait for the pipeline 
        #(2 * K * CLK_CYCLE)
        $finish;
    end

endmodule
