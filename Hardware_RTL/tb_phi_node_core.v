%%writefile tb_phi_node_core.v
`timescale 1ns / 1ps

module tb_phi_node_core;

    reg clk;
    reg rst_n;
    reg [7:0] host_p_value;
    reg [7:0] host_seed;
    reg incoming_stream_a;
    reg sample_window_en;
    
    wire [7:0] resolved_binary;
    wire hardware_alert;

    // Connect top-level core module
    phi_node_core uut (
        .clk(clk),
        .rst_n(rst_n),
        .host_p_value(host_p_value),
        .host_seed(host_seed),
        .incoming_stream_a(incoming_stream_a),
        .sample_window_en(sample_window_en),
        .resolved_binary(resolved_binary),
        .hardware_alert(hardware_alert)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0; incoming_stream_a = 0; sample_window_en = 0;
        host_p_value = 8'd255; // Set target close to 100% logic high density
        host_seed = 8'h3C;

        #10 rst_n = 1;
        #10 sample_window_en = 1; // Open elastic parsing matrix

        // Force a multi-cycle data stream input onto line A
        repeat (12) begin
            #10 incoming_stream_a = 1;
        end

        #10 sample_window_en = 0; // Latch final computation data out
        #20;
        $finish;
    end

    initial begin
        $monitor("Time=%0dns | Alert=%b | Latching_Out=%d", $time, hardware_alert, resolved_binary);
    end

endmodule
