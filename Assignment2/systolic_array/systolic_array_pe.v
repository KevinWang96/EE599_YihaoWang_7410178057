/*
 * @Author: Yihao Wang
 * @Date: 2020-03-27 03:15:13
 * @LastEditTime: 2020-04-02 02:22:18
 * @LastEditors: Please set LastEditors
 * @Description: Processing element of systolic array
                 Performing function C <= C + A * B
 * @FilePath: /Assignment2/systolic_array/systolic_array_pe.v
 */
 module systolic_array_pe #(
     parameter input_width = 8 
 )
 (
     input clk, reset, // sync active high reset
     input [0:input_width - 1]  in_a, in_b,
     output [0:input_width - 1] out_a, out_b, 
     output [0:2 * input_width - 1] out_c
 );
    reg [0:input_width - 1] a_r, b_r;
    reg [0:2 * input_width - 1] c_r; // output register for a, b, c;
    
    always @(posedge clk)
    begin
        if(reset) {a_r, b_r, c_r} <= 0;
        else
        begin
            a_r <= in_a;
            b_r <= in_b;
            c_r <= in_a * in_b + c_r;
        end
    end

    assign out_a = a_r;
    assign out_b = b_r;
    assign out_c = c_r;

 endmodule
