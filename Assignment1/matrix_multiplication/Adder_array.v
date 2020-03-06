/*
    k parallel adders with output register
*/
module Adder_array #(
    parameter k = 4, // number of adders in this array
    parameter WIDTH = 16 // width of each input
)
(
    input [2 * k * WIDTH - 1:0] in, // combine A and B
    input clk, reset, // asynchronous hign active reset
    output [k * WIDTH - 1:0] sum  
);

    genvar i;
    generate 
    begin
        for(i = 1; i <= k; i = i + 1)
        begin : for_loop
            Adder
            #(
                .k(WIDTH)
            )
            adder
            (
                .clk(clk),
                .reset(reset),
                .A(in[(2 * i * WIDTH - 1)-:WIDTH]),
                .B(in[((2 * i - 1) * WIDTH - 1)-:WIDTH]),
                .sum(sum[(i * WIDTH - 1)-:WIDTH])
            );
            
        end
    end
    endgenerate

endmodule