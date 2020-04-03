 `define data_width 8
 `define dimension 16
 `timescale 1ns/1ps
/*
 * @Author: Yihao Wang
 * @Date: 2020-03-27 16:49:04
 * @LastEditTime: 2020-04-02 19:49:50
 * @LastEditors: Please set LastEditors
 * @Description: Testbench used for testing systolic array
 * @FilePath: /Assignment2/tb_systolic_array.v
 */
 module tb_systolic_array;
    
    parameter CLK_CYCLE = 10; // clock cycle time

    reg clk, reset;  
    reg [0:`dimension * `data_width - 1] in_a, in_b;
    wire [0:(`dimension ** 2) * 2 * `data_width - 1]  out_c;

    reg [0: `data_width - 1] metrix_a [`dimension - 1:0][`dimension - 1:0];
    reg [0: `data_width - 1] metrix_b [`dimension - 1:0][`dimension - 1:0];

    // Initiates contents of two input metrixes with random number
    initial
    begin : init_metrix
        integer i, j;

        for(i = 0; i < `dimension; i = i + 1)
            for(j = 0; j < `dimension; j = j + 1)
            begin
                metrix_a[i][j] = {$random} % (2 ** ((2 * `data_width - $clog2(`dimension)) / 2));
                metrix_b[i][j] = {$random} % (2 ** ((2 * `data_width - $clog2(`dimension)) / 2)); // use small number to avoid overflow
            end

    end


    // Generates clcok
    always #(0.5 * CLK_CYCLE) clk = ~ clk;


    // Instantiation of DUT:
    systolic_array #(
        .m(`dimension),
        .n(`dimension),
        .input_width(`data_width)
    )
    systolic_array_dut
    (
        .clk(clk),
        .reset(reset),
        .in_col(in_b),
        .in_row(in_a),
        .out(out_c)
    );


    integer log_file;
    initial 
    begin : test
        integer i, j, k; // used in nested for loop
        integer sum; // used to check the results
        reg flag; // used to mark the correctness of results

        log_file = $fopen("systolic_array.res", "w");

        // print out the two input metrixes into log files
        $fdisplay(log_file, " Input metrix A:");
        for(i = 0; i < `dimension; i = i + 1)
        begin
            for(j = 0; j < `dimension; j = j + 1)
            begin
                $fwrite(log_file, "%3d(0x%h)  ", metrix_a[i][j], metrix_a[i][j]);
                if(j + 1 >= `dimension) 
                    $fwrite(log_file, "\n\n");
            end
        end
        $fdisplay(log_file, "\nInput metrix B:");
        for(i = 0; i < `dimension; i = i + 1)
        begin
            for(j = 0; j < `dimension; j = j + 1)
            begin
                $fwrite(log_file, "%3d(0x%h)  ", metrix_b[i][j], metrix_b[i][j]);
                if(j + 1 >= `dimension) 
                    $fwrite(log_file, "\n\n");
            end
        end

        clk = 1;
        reset = 1;

        #(3.5 * CLK_CYCLE)
        reset = 0;

        for(i = 0; i < 2 * `dimension - 1; i = i + 1)
        begin
            for(j = 0; j < `dimension; j = j + 1)
            begin
                if((i - j >= 0) && (i - j < `dimension) && (j >= 0) && (j < `dimension))
                begin
                    in_a[(j * `data_width)+:`data_width] = metrix_a[j][i - j];
                    in_b[(j * `data_width)+:`data_width] = metrix_b[i - j][j];
                end
                else
                begin
                    in_a[(j * `data_width)+:`data_width] = {`data_width{1'b0}};
                    in_b[(j * `data_width)+:`data_width] = {`data_width{1'b0}};
                end
            end

            #(CLK_CYCLE);
        end
        
        in_a = 0;
        in_b = 0;
        #(2 * `dimension * CLK_CYCLE); // make sure all processing unit finished calculation

        // Prints out the result metrix
        $fdisplay(log_file, "The result metrix is:");
        for(i = 0; i < `dimension; i = i + 1)
        begin
            for(j = 0; j < `dimension; j = j + 1)
            begin
                $fwrite(log_file, "%4d(0x%h)  ", out_c[((i * `dimension + j) * 2 * `data_width)+:2 * `data_width],
                        out_c[((i * `dimension + j) * 2 * `data_width)+:2 * `data_width]);
                if(j + 1 >= `dimension) 
                    $fwrite(log_file, "\n\n");
            end
        end

`define TRUE 1
`define FALSE 0

        // Checks the results
        sum = 0;
        flag = `TRUE;
        for(i = 0; i < `dimension; i = i + 1)
        begin : checker
            for(j = 0; j < `dimension; j = j + 1)
            begin

                // calculates expected results
                for(k = 0; k < `dimension; k = k + 1)
                    sum = sum + metrix_a[i][k] * metrix_b[k][j]; 
                
                // checks if results are overflow
                if(sum >= (2 ** (2 * `data_width)))
                begin
                    $fdisplay(log_file, "element[%1d, %1d] is overflow;", i, j);
                    flag = `FALSE;
                    disable result_check;
                end
                
                // if the results doesn't match with expected results
                if(sum != out_c[((i * `dimension + j) * 2 * `data_width)+:2 * `data_width]) 
                begin : result_check
                    $fwrite(log_file, "element[%1d, %1d] is wrong;", i, j);
                    $fdisplay(log_file, " the result is: %4d(0x%h), the expected result is %4d(0x%h)",
                            out_c[((i * `dimension + j) * 2 * `data_width)+:2 * `data_width],
                            out_c[((i * `dimension + j) * 2 * `data_width)+:2 * `data_width],
                            sum, sum);
                    flag = `FALSE;
                end

                sum = 0; // reset sum again
            end
        end

        if(flag) $fdisplay(log_file, "Test passed!");
        else $fdisplay(log_file, "Test Failed!");

`undef TRUE
`undef FALSE
    
        #(10 * CLK_CYCLE)
        $fclose(log_file);
        $finish;    
    end


 endmodule
`undef dimension
`undef data_width