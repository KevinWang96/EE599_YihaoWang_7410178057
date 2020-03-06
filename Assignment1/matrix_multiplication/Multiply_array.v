module Multiply_array #(
    parameter k = 8, // number of multipliers
    parameter WIDTH = 8 // width of inputs
)
(
    input [k * WIDTH - 1:0] A, B,
    input clk, reset, // asynchronous hign active reset
    output [k * 2 * WIDTH - 1:0] product
);

    genvar i;
    generate 
    begin
        for(i = 1; i <= k; i = i + 1)
        begin : for_loop
            Multiply
            #(
                .k(WIDTH)
            )
            mult
            (
                .clk(clk), 
                .reset(reset),
                .A(A[(i * WIDTH - 1)-:WIDTH]),
                .B(B[(i * WIDTH - 1)-:WIDTH]),
                .product(product[(i * 2 * WIDTH - 1)-:2 * WIDTH])
            );
        end
    end
    endgenerate

endmodule