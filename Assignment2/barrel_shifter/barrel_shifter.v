/*
 * @Author: Yihao Wang
 * @Date: 2020-03-13 12:46:54
 * @LastEditTime: 2020-03-15 03:58:42
 * @LastEditors: Please set LastEditors
 * @Description: Pipeline barrel shifter
 * @FilePath: /EE599_YihaoWang_7410178057/Assignment2/barrel_shifter.v
 */
 module barrel_shifter #(
     parameter N = 16, // N should be 2 power of K
     parameter K = 4, // k = log(N)
     parameter WIDTH = 8 // width of input number
 )
 (
     input clk, 
     input [N * WIDTH - 1:0] in,
     input [K - 1:0] sel, // k-bit select signal
     output [N * WIDTH - 1:0] out
 );

    wire [N * WIDTH - 1:0] stage_wire [K:0];
    wire [K - 1:0] sel_wire [K:0]; 

    assign stage_wire[0] = in;
    assign sel_wire[0] = sel;

    genvar i;
    generate
    begin
        for(i = 0; i < K; i = i + 1)
        begin : for_loop

            barrel_shifter_1stage #(
                .N(N),
                .WIDTH(WIDTH),
                .SHIFT_VALUE(2 ** i),
                .K(K),
                .STAGE_NUM(i)
            )
            shifter
            (
                .clk(clk),
                .in(stage_wire[i]),
                .sel(sel_wire[i]),
                .out(stage_wire[i+1]),
                .sel_out(sel_wire[i+1])
            );
        
        end
    end
    endgenerate

    assign out = stage_wire[K];

 endmodule