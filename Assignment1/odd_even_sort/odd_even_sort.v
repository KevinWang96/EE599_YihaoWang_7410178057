/*
    Odd-even sort using n-stage pipeline 
    n should be an even number
*/
module odd_even_sort #(
    parameter n = 64, // number of input number
    parameter k = 8 // the width of each input
)
(
    input [n * k - 1:0] in,
    input clk, reset, // async hign active reset
    output [n * k - 1:0] out
);
    reg[n * k - 1:0] input_reg;// input register

    // launch input data into inputs register
    always @(posedge clk, posedge reset)
    begin
       if(reset) 
            input_reg <= 0;
        else
            input_reg <= in; 
    end

    wire [n * k - 1:0] stage_wire [n:0]; // wires used to connect each two stages
    assign stage_wire[0] = input_reg;

    genvar i;
    generate
    begin
        for(i = 0; i < n; i = i + 1)
        begin : stage_loop

            // instantiate stage module to form a pipeline
            odd_even_sort_stage 
            #(
                .n(n),
                .k(k),
                .ODD_EVEN(i % 2)
            )
            stage
            (
                .clk(clk),
                .reset(reset),
                .in(stage_wire[i]),
                .out(stage_wire[i + 1])
            );
        end
    end
    endgenerate

    assign out = stage_wire[n];

endmodule

        
                

