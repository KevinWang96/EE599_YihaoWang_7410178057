/* 
    Muland Adder Tree used to generate an elements in matrix multiplcation
*/
module MulandAddTree #(
    parameter n = 4, // n * n matrix, n is even number
    parameter WIDTH = 8 // the width of each input
)
(
    input clk, reset, // async hign active reset
    input [n * WIDTH - 1:0] A, B,
    output [2 * WIDTH - 1:0] out
);

    wire [2 * n * WIDTH - 1:0] stage [n - 1:0]; // used to connect each pairs of stage

    // Instantiation of Multiplier array
    Multiply_array  
    #(
        .k(n),
        .WIDTH(WIDTH)
    )
    mult_stage
    (
        .A(A),
        .B(B),
        .clk(clk),
        .reset(reset),
        .product(stage[0])
    );


    genvar i;
    generate 
    begin
        for(i = 0; (n / (2 ** (i + 1))) >= 1; i = i + 1)
        begin : for_loop
            Adder_array
            #(
                .k(n / (2 ** (i + 1))),
                .WIDTH(2 * WIDTH)
            )
            add_stage
            (
                .clk(clk),
                .reset(reset),
                .in(stage[i][(n / (2 ** i)) * 2 * WIDTH - 1:0]),
                .sum(stage[i + 1][(n / (2 ** (i + 1))) * 2 * WIDTH - 1:0])
            );

            // outputs
            if((n / (2 ** (i + 1))) == 1)
                assign out = stage[i + 1];
        end
    end
    endgenerate
endmodule
