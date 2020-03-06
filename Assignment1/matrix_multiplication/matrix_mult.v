/* 
    Matrix multiplier for two nxn matrixes
    It uses nxn muland adder tree in parallel
*/
module matrix_mult #(
    parameter n = 4,
    parameter WIDTH = 8
)
(
    input clk, reset,
    input [(n ** 3) * WIDTH - 1:0] A, B,
    output [2 * WIDTH * (n ** 2) - 1:0] out
);

    genvar i;
    generate
    begin
        for(i = 1; i <= n * n; i = i + 1)
        begin : for_loop
            MulandAddTree
            #(
                .n(n),
                .WIDTH(WIDTH)
            ) 
            tree
            (
                .clk(clk),
                .reset(reset),
                .A(A[i * n * WIDTH - 1:0]),
                .B(B[i * n * WIDTH - 1:0]),
                .out(out[i * 2 * WIDTH - 1:0])
            );
        end
    end
    endgenerate
endmodule
