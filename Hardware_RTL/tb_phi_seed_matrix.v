%%writefile tb_phi_seed_matrix.v
`timescale 1ns / 1ps

module tb_phi_seed_matrix;

    reg clk;
    reg rst_n;
    reg [7:0] master_iv;
    wire [7:0] core_seed_0, core_seed_1, core_seed_2, core_seed_3;

    // Connect the seed distribution matrix
    phi_seed_matrix uut (
        .clk(clk),
        .rst_n(rst_n),
        .master_iv(master_iv),
        .core_seed_0(core_seed_0),
        .core_seed_1(core_seed_1),
        .core_seed_2(core_seed_2),
        .core_seed_3(core_seed_3)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0; master_iv = 8'hD4;
        #10 rst_n = 1;
        #50;
        $finish;
    end

    initial begin
        $monitor("Time=%0dns | Reset=%b | Seed0=%h | Seed1=%h | Seed2=%h | Seed3=%h", 
                 $time, rst_n, core_seed_0, core_seed_1, core_seed_2, core_seed_3);
    end

endmodule
