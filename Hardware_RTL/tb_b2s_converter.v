%%writefile tb_b2s_converter.v
`timescale 1ns / 1ps

module tb_b2s_converter;

    reg clk;
    reg rst_n;
    reg [7:0] p_value;
    reg [7:0] seed;
    wire stochastic_out;

    // Instantiate the converter hardware
    b2s_converter uut (
        .clk(clk),
        .rst_n(rst_n),
        .p_value(p_value),
        .seed(seed),
        .stochastic_out(stochastic_out)
    );

    // Generate clock line (toggles every 5ns)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        
        // Target: 192/256 = 0.75 (75% high density pulse train)
        p_value = 8'd192; 
        seed = 8'h5A;

        #10 rst_n = 1; // Release reset
        
        #200; // Let the hardware stream run for 200ns
        $finish;
    end

    initial begin
        $monitor("Time=%0dns | Reset=%b | Target Prob P(x)=0.75 | Pulse Output=%b", $time, rst_n, stochastic_out);
    end

endmodule
