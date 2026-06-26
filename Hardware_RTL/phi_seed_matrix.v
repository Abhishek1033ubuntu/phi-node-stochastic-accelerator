%%writefile phi_seed_matrix.v
// phi_seed_matrix.v
// Phase 3: Orthogonal Seed Distribution Network for Scaled P-Bit Array

module phi_seed_matrix (
    input wire clk,                        // System clock
    input wire rst_n,                      // Active-low reset
    input wire [7:0] master_iv,            // Master initialization vector
    output reg [7:0] core_seed_0,          // Dedicated independent seed for Core 0
    output reg [7:0] core_seed_1,          // Dedicated independent seed for Core 1
    output reg [7:0] core_seed_2,          // Dedicated independent seed for Core 2
    output reg [7:0] core_seed_3           // Dedicated independent seed for Core 3
);

    // Internal entropy-spinning register (16-bit internal Galois LFSR)
    reg [15:0] entropy_shifter;
    wire poly_feedback = entropy_shifter[15] ^ entropy_shifter[13] ^ entropy_shifter[12] ^ entropy_shifter[10];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            entropy_shifter <= {master_iv, ~master_iv};
            core_seed_0     <= 8'hA5;
            core_seed_1     <= 8'h5A;
            core_seed_2     <= 8'h3C;
            core_seed_3     <= 8'hC3;
        end else begin
            // Spin the entropy state to generate non-repeating orthogonal slices
            entropy_shifter <= {entropy_shifter[14:0], poly_feedback};
            
            // Distribute mathematically distinct taps to the core cluster array
            core_seed_0     <= entropy_shifter[7:0];
            core_seed_1     <= entropy_shifter[15:8];
            core_seed_2     <= ~entropy_shifter[7:0] ^ master_iv;
            core_seed_3     <= ~entropy_shifter[15:8] ^ {master_iv[3:0], master_iv[7:4]};
        end
    end

endmodule
