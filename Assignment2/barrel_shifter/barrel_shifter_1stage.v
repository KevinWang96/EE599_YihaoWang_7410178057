/*
 * @Author: Yihao Wang
 * @Date: 2020-03-13 12:25:52
 * @LastEditTime: 2020-04-03 15:18:43
 * @LastEditors: Please set LastEditors
 * @Description: One stage of barrel shifter design
 * @FilePath: /EE599_YihaoWang_7410178057/Assignment2/barrel_shifter_1stage.v
 */
 module barrel_shifter_1stage #(
    parameter N = 16, // # of elements
    parameter WIDTH = 8, // data width
    parameter SHIFT_VALUE = 1, // shift offset
    parameter K = 4, // K = log2(N) 
    parameter STAGE_NUM = 0 // range from 0 to K-1
 )
 (  
    input clk, 
    input [N * WIDTH - 1:0] in,
    input [K - 1:0] sel, // K-bit select signal
    output [N * WIDTH - 1:0] out,
    output [K - 1:0] sel_out
 );

    reg [N * WIDTH - 1:0] stage_reg; // stage register
    reg [K - 1:0] sel_reg; // register the K-1 bits select signal

    // Register select signal to next stage
    always @(posedge clk)
    begin
        sel_reg <= sel;
    end
    

    genvar count;
    generate
    begin
        for(count = 0; count < N; count = count + 1)
        begin : for_loop

            always @(posedge clk)
            begin
                if(sel[STAGE_NUM]) // shift data by SHIFT_VALUE bit
                    stage_reg[((((count + SHIFT_VALUE) % N) + 1) * WIDTH - 1)-:WIDTH] <= in[((count + 1) * WIDTH - 1)-:WIDTH];
                else // carry data to output as it is
                    stage_reg[((count + 1) * WIDTH - 1)-:WIDTH] <= in[((count + 1) * WIDTH - 1)-:WIDTH];
            end

        end
    end
    endgenerate

    assign out = stage_reg;
    assign sel_out = sel_reg;

 endmodule


