%%writefile tb_s2b_converter.v
`timescale 1ns / 1ps

module tb_s2b_converter;

    reg clk;
    reg rst_n;
    reg stochastic_in;
    reg sample_en;
    wire [7:0] binary_out;

    // Instantiate hardware integrator
    s2b_converter uut (
        .clk(clk),
        .rst_n(rst_n),
        .stochastic_in(stochastic_in),
        .sample_en(sample_en),
        .binary_out(binary_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0; stochastic_in = 0; sample_en = 0;
        #10 rst_n = 1;

        // Start sample window (Elastic window running for 100ns = 10 active cycles)
        #10 sample_en = 1;
        
        // Feed a pulse stream with exactly 60% density (6 out of 10 cycles are high)
        #10 stochastic_in = 1;
        #10 stochastic_in = 1;
        #10 stochastic_in = 0;
        #10 stochastic_in = 1;
        #10 stochastic_in = 0;
        #10 stochastic_in = 1;
        #10 stochastic_in = 1;
        #10 stochastic_in = 0;
        #10 stochastic_in = 1;
        #10 stochastic_in = 0;

        // Close window to latch data out
        #10 sample_en = 0;
        
        #20;
        $finish;
    end

    initial begin
        $monitor("Time=%0dns | Reset=%b | Window_Active=%b | In_Pulse=%b | Integrated_Binary_Out=%d", 
                 $time, rst_n, sample_en, stochastic_in, binary_out);
    end

endmodule
