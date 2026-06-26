%%writefile s2b_converter.v
// s2b_converter.v
// Phase 2: Stochastic-to-Binary Integration Layer (Elastic Precision)

module s2b_converter (
    input wire clk,                  // High-frequency system clock line
    input wire rst_n,                // Active-low asynchronous reset
    input wire stochastic_in,        // The incoming 1-bit processed stochastic stream
    input wire sample_en,            // High to accumulate pulses, low to hold value
    output reg [7:0] binary_out      // The final integrated 8-bit binary value
);

    // Internal accumulation counter
    reg [7:0] pulse_accumulator;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pulse_accumulator <= 8'h00;
            binary_out        <= 8'h00;
        end else begin
            if (sample_en) begin
                // Accumulate every clock cycle if the pulse stream is high
                if (stochastic_in) begin
                    pulse_accumulator <= pulse_accumulator + 1'b1;
                end
            end else begin
                // Output the integrated result and clear internal cache for the next window
                binary_out        <= pulse_accumulator;
                pulse_accumulator <= 8'h00;
            end
        end
    end

endmodule
