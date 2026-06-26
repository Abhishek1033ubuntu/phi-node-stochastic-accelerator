%%writefile phi_array_top.v
// phi_array_top.v
// Phase 3: Macro-Scale Parallel Coprocessor Array Interconnect

module phi_array_top (
    input wire clk,                           // Master high-frequency clock
    input wire rst_n,                         // Active-low master reset
    input wire [7:0] master_entropy_iv,       // Main entropy initialization vector
    input wire [7:0] host_p_target,           // Probability input target from x86 Host
    input wire [3:0] parallel_streams_a,      // 4-channel parallel input wave vector
    input wire global_sample_en,              // Elastic precision tracking window line
    output wire [7:0] out_binary_0,           // Resolved register output for Core 0
    output wire [7:0] out_binary_1,           // Resolved register output for Core 1
    output wire [7:0] out_binary_2,           // Resolved register output for Core 2
    output wire [7:0] out_binary_3,           // Resolved register output for Core 3
    output wire [3:0] global_hardware_alerts  // 4-channel real-time FeFET intervention flags
);

    // Structural routing lines for internal seed distribution
    wire [7:0] seed_wire_0;
    wire [7:0] seed_wire_1;
    wire [7:0] seed_wire_2;
    wire [7:0] seed_wire_3;

    // 1. Instantiate the Master Seeding Network
    phi_seed_matrix seed_matrix_inst (
        .clk(clk),
        .rst_n(rst_n),
        .master_iv(master_entropy_iv),
        .core_seed_0(seed_wire_0),
        .core_seed_1(seed_wire_1),
        .core_seed_2(seed_wire_2),
        .core_seed_3(seed_wire_3)
    );

    // 2. Instantiate 4 Parallel Φ-Node Hardware Cores linked to the Seeding Matrix
    phi_node_core core_0 (
        .clk(clk),
        .rst_n(rst_n),
        .host_p_value(host_p_target),
        .host_seed(seed_wire_0),
        .incoming_stream_a(parallel_streams_a[0]),
        .sample_window_en(global_sample_en),
        .resolved_binary(out_binary_0),
        .hardware_alert(global_hardware_alerts[0])
    );

    phi_node_core core_1 (
        .clk(clk),
        .rst_n(rst_n),
        .host_p_value(host_p_target),
        .host_seed(seed_wire_1),
        .incoming_stream_a(parallel_streams_a[1]),
        .sample_window_en(global_sample_en),
        .resolved_binary(out_binary_1),
        .hardware_alert(global_hardware_alerts[1])
    );

    phi_node_core core_2 (
        .clk(clk),
        .rst_n(rst_n),
        .host_p_value(host_p_target),
        .host_seed(seed_wire_2),
        .incoming_stream_a(parallel_streams_a[2]),
        .sample_window_en(global_sample_en),
        .resolved_binary(out_binary_2),
        .hardware_alert(global_hardware_alerts[2])
    );

    phi_node_core core_3 (
        .clk(clk),
        .rst_n(rst_n),
        .host_p_value(host_p_target),
        .host_seed(seed_wire_3),
        .incoming_stream_a(parallel_streams_a[3]),
        .sample_window_en(global_sample_en),
        .resolved_binary(out_binary_3),
        .hardware_alert(global_hardware_alerts[3])
    );

endmodule
