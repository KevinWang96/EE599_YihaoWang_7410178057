/* 
    k-bits multiplier
*/
module Multiply #(
    parameter k = 8 // the input is k bits
)
(
    input [k - 1:0] A, B,
    input clk, reset, // async hign active reset
    output [2 * k - 1:0] product
);
    reg [2 * k - 1:0] out_reg;
    always @(posedge clk, posedge reset)
    begin
        if(reset) 
            out_reg <= 0;
        else
            out_reg <= A * B;
    end

    assign product = out_reg;
    
endmodule


