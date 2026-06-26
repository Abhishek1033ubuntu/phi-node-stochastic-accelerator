%%writefile tb_phase_cross_correlator.v
`timescale 1ns / 1ps

module tb_phase_cross_correlator;

    reg clk;
    reg rst_n;
    reg stream_a;
    reg stream_b;
    wire corrected_stream_b;
    wire correlation_alert;

    // Instantiate hardware
    phase_cross_correlator uut (
        .clk(clk),
        .rst_n(rst_n),
        .stream_a(stream_a),
        .stream_b(stream_b),
        .corrected_stream_b(corrected_stream_b),
        .correlation_alert(correlation_alert)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0; stream_a = 0; stream_b = 0;
        #10 rst_n = 1;

        // --- TEST CASE 1: Independent Waves ---
        #10 stream_a = 1; stream_b = 0;
        #10 stream_a = 0; stream_b = 1;

        // --- TEST CASE 2: Forced Correlation Lock ---
        repeat (10) begin
            #10 stream_a = 1; stream_b = 1;
        end

        #20;
        $finish;
    end

    initial begin
        $monitor("Time=%0dns | A=%b | B=%b | Alert=%b | Corrected_B=%b", 
                 $time, stream_a, stream_b, correlation_alert, corrected_stream_b);
    end

endmodule
