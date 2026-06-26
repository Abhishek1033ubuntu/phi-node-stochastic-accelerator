%%writefile b2s_converter.v
// b2s_converter.v
// Phase 2: Binary-to-Stochastic Conversion for the Φ-Node Core

module b2s_converter (
    input wire clk,           // High-frequency system clock line
    input wire rst_n,         // Active-low asynchronous reset
    input wire [7:0] p_value, // 8-bit Target Probability (Binary input from 0 to 255)
    input wire [7:0] seed,    // Unique initial seed to guarantee stream independence
    output wire stochastic_out // The resulting 1-bit high-frequency pulse stream
);

    reg [7:0] lfsr_reg;
    wire feedback = lfsr_reg[7] ^ lfsr_reg[5] ^ lfsr_reg[4] ^ lfsr_reg[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr_reg <= (seed == 8'h00) ? 8'hA5 : seed; 
        end else begin
            lfsr_reg <= {lfsr_reg[6:0], feedback};
        end
    end

    assign stochastic_out = (lfsr_reg < p_value) ? 1'b1 : 1'b0;

endmodule
