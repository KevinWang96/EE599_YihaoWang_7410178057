/*
 * @Author: Yihao Wang
 * @Date: 2020-03-27 03:23:37
 * @LastEditTime: 2020-04-02 02:20:41
 * @LastEditors: Please set LastEditors
 * @Description: mxn Systolic array used for matrix multiplication
 * @FilePath: /Assignment2/systolic_array.v
 */
 module systolic_array #(
     parameter m = 16, // m rows
     parameter n = 16, // n columns
     parameter  input_width = 8
 )
 (
     input clk, reset,
     input [0:m * input_width - 1] in_row, // row input
     input [0:n * input_width - 1] in_col, // column input
     output [0:m * n * 2 * input_width - 1] out
 );

    // wires used to connect processing element
    wire [0:n * input_width - 1] col_wire [0:m];
    wire [0:m * input_width - 1] row_wire [0:n];

    assign col_wire[0] = in_col;
    assign row_wire[0] = in_row;

    // generates 2-dimension processing elements array in loop
    genvar i, j;
    generate
    begin
        for(i = 0; i < m; i = i + 1)
        begin : for_row
            for(j = 0; j < n; j = j + 1)
            begin : for_col

                systolic_array_pe #(
                    .input_width(input_width)
                )
                pe
                (
                    .clk(clk),
                    .reset(reset),
                    .in_a( row_wire[j][ (i * input_width)+:input_width ] ),
                    .in_b( col_wire[i][ (j * input_width)+:input_width ] ),
                    .out_a( row_wire[j + 1][ (i * input_width)+:input_width ] ),
                    .out_b( col_wire[i + 1][ (j * input_width)+:input_width ] ),
                    .out_c( out[ ((i * n + j) * 2 * input_width)+:2 * input_width] )
                );
                
            end
        end
    end
    endgenerate

 endmodule
