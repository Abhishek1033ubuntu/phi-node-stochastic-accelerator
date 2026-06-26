%%writefile tb_phi_array_top.v
`timescale 1ns / 1ps

module tb_phi_array_top;

    reg clk;
    reg rst_n;
    reg [7:0] master_entropy_iv;
    reg [7:0] host_p_target;
    reg [3:0] parallel_streams_a;
    reg global_sample_en;

    wire [7:0] out_binary_0, out_binary_1, out_binary_2, out_binary_3;
    wire [3:0] global_hardware_alerts;

    // Connect our master coprocessor array
    phi_array_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .master_entropy_iv(master_entropy_iv),
        .host_p_target(host_p_target),
        .parallel_streams_a(parallel_streams_a),
        .global_sample_en(global_sample_en),
        .out_binary_0(out_binary_0),
        .out_binary_1(out_binary_1),
        .out_binary_2(out_binary_2),
        .out_binary_3(out_binary_3),
        .global_hardware_alerts(global_hardware_alerts)
    );

    // 100 MHz clock source definition
    always #5 clk = ~clk;

    initial begin
        // Setup control parameters
        clk = 0; rst_n = 0; global_sample_en = 0;
        master_entropy_iv = 8'hE2;
        host_p_target = 8'd255; // High-density stream configurations
        parallel_streams_a = 4'b0000;

        #10 rst_n = 1;
        #10 global_sample_en = 1; // Open elastic precision accumulation windows

        // Simulate independent acoustic wave lines arriving into the array core channels
        repeat (12) begin
            #10 parallel_streams_a = 4'b1111; // Heavy load concurrent input data lines
        end

        #10 global_sample_en = 0; // Latch all output data registers to host bus
        #20;
        $finish;
    end

    initial begin
        $monitor("Time=%0dns | Alerts[3:0]=%b | Resolved Core Outputs: C0=%d, C1=%d, C2=%d, C3=%d", 
                 $time, global_hardware_alerts, out_binary_0, out_binary_1, out_binary_2, out_binary_3);
    end

endmodule
