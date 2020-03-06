`timescale 1ns/1ps
module tb_odd_even_sort;
    parameter NUM_OF_INPUT = 4;
    parameter WIDTH_OF_INPUT = 8;
    parameter CLK_CYCLE = 10;
    parameter NUM_OF_TEST = 30;

    reg rst, clk;
    reg [NUM_OF_INPUT * WIDTH_OF_INPUT - 1:0] in;
    wire [NUM_OF_INPUT * WIDTH_OF_INPUT - 1:0] out;

    
    odd_even_sort #(
        .n(NUM_OF_INPUT),
        .k(WIDTH_OF_INPUT)
    )
    odd_even_sort_dut (
        .clk(clk),
        .reset(rst),
        .in(in),
        .out(out)
    );

    always #(0.5 * CLK_CYCLE) clk = ~ clk;

    initial
    begin : test_loop
        integer count, i;
        clk = 1;
        rst = 1;
        #(3.5 * CLK_CYCLE)
        rst = 0;
        for(count = 0; count < NUM_OF_TEST; count = count + 1)
        begin
            for(i = 0; i < NUM_OF_INPUT; i = i + 1)
                in[((i + 1) * WIDTH_OF_INPUT - 1)-:WIDTH_OF_INPUT] = {$random} % (2 ** WIDTH_OF_INPUT);
            #(CLK_CYCLE);
        end
        #(1.5 * NUM_OF_INPUT * CLK_CYCLE)
        $finish;
    end

endmodule