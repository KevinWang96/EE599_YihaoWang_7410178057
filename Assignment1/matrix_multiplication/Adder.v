module Adder #(
    parameter k = 16
)
(
    input clk, reset, // asynchronous hign active reset
    input [k - 1:0] A, B, // k-bit input
    output [k - 1:0] sum, // k+1 bit sum
    output carry
);
    reg [k:0] out_reg;
    always @(posedge clk, posedge reset)
    begin
        if(reset) out_reg <= 0;
        else out_reg <= A + B;
    end

    assign {carry, sum} = out_reg;
endmodule