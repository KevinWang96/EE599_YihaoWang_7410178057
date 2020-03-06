`timescale 1ns/1ps

module tb_MulandAddTree;
    parameter n = 4; // nxn matrix
    parameter WIDTH = 8; // width of each input

    parameter CLK_CYCLE = 10;

    parameter NUM_OF_TEST = 40; // how many test patterns

    reg [n * WIDTH - 1:0] A, B;
    reg clk, reset;

    wire [2 * WIDTH - 1:0] out;

    // DUT 
    MulandAddTree 
    #(
        .n(n),
        .WIDTH(WIDTH)
    )    
    dut
    (
        .clk(clk),
        .reset(reset),
        .A(A),
        .B(B),
        .out(out)
    );

    always #(0.5 * CLK_CYCLE) clk = ~ clk;

    initial 
    begin : test
        integer count, num_of_case;

        reset = 1;
        clk = 1;

        #(3 * CLK_CYCLE) 
        reset = 0;

        for(num_of_case = 0; num_of_case < NUM_OF_TEST; num_of_case = num_of_case + 1)
        begin
            for(count = 1; count <= n; count = count + 1)
            begin
                A[(count * WIDTH - 1)-:WIDTH] = {$random} % (2 ** 4); // generate a row of A matrix with ramdom number
                B[(count * WIDTH - 1)-:WIDTH] = {$random} % (2 ** 4); // generate a column of B matrix with ramdom number
            end

            #(CLK_CYCLE);
        end

        #(2 * n * CLK_CYCLE)
        $finish;
    end
endmodule