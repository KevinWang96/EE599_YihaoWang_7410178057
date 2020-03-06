/*
    One stage of odd even sort
    The results are registered by DFF arrays
*/
module odd_even_sort_stage #(
    parameter n = 8, // number of inputs number
    parameter k = 8, // the width of each input
    parameter ODD_EVEN = 0 // 0 means sorting even pairs; 1 means sorting odd pairs
)
(
    input clk, reset, // async hign active reset
    input [n * k - 1:0] in,
    output [n * k -1:0] out   
);
    reg [n * k - 1:0] out_reg; // output register

    genvar i;
    generate
    begin
       if(ODD_EVEN == 0) //for odd row
       begin
            for(i = 0; i <= n / 2 - 1; i = i + 1)
            begin : always_loop_odd
            
                always @(posedge clk, posedge reset)
                begin
                    if(reset) 
                        out_reg[((2 * i + 2) * k - 1)-:2 * k] <= 0;
                    else
                        if(in[((2 * i + 1) * k - 1)-:k] <= in[((2 * i + 2) * k - 1)-:k])
                        begin
                            // switch two number
                            out_reg[((2 * i + 1) * k - 1)-:k] <= in[((2 * i + 2) * k - 1)-:k];
                            out_reg[((2 * i + 2) * k - 1)-:k] <= in[((2 * i + 1) * k - 1)-:k];
                        end
                        else
                            out_reg[((2 * i + 2) * k - 1)-:2 * k] <= in[((2 * i + 2) * k - 1)-:2 * k];
                end
            end
        end
        else // for even row
        begin
            for(i = 1; i <= n / 2 - 1; i = i + 1)
            begin : always_loop_even

                always @(posedge clk, posedge reset)
                begin
                    if(reset)
                        out_reg[((2 * i + 1) * k - 1)-:2 * k] <= 0;
                    else
                        if(in[((2 * i) * k - 1)-:k] <= in[((2 * i + 1) * k - 1)-:k])
                        begin
                            out_reg[((2 * i) * k - 1)-:k] <= in[((2 * i + 1) * k - 1)-:k];
                            out_reg[((2 * i + 1) * k - 1)-:k] <= in[((2 * i) * k - 1)-:k];
                        end
                        else
                            out_reg[((2 * i + 1) * k - 1)-:2 * k] <= in[((2 * i + 1) * k - 1)-:2 * k];
                end

            end
            
            // carry two number at both sides into output register
            always @(posedge clk, posedge reset)
            begin
                if(reset) 
                begin
                    out_reg[k - 1:0] <= 0;
                    out_reg[(n * k - 1)-:k] <= 0;
                end
                else
                begin
                    out_reg[k - 1:0] <= in[k - 1:0];
                    out_reg[(n * k - 1)-:k] <= in[(n * k - 1)-:k]; 
                end
            end
            
        end
    end
    endgenerate

    assign out = out_reg;

endmodule