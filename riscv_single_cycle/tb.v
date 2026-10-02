`timescale 1ns / 1ps

module tb;

    // 1. Inputs to DUT are declared as reg
    reg clk;
    reg rst;
    reg [31:0] pc_next;

    // 2. Outputs from DUT are declared as wire
    wire [31:0] pc;
    wire [31:0] pc_plus4;

    // 3. Instantiate the Units Under Test (DUT)
    program_counter u_pc (
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc(pc)
    );

    pc_adder u_adder (
        .pc(pc),
        .pc_plus4(pc_plus4)
    );

    // 4. Clock generation: toggles every 5ns -> Period = 10ns (100 MHz)
    always #5 clk = ~clk;

    // 5. Test Stimulus
    initial begin
        // Generate VCD waveform file
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        // Print header and monitor signal changes
        $display("----------------------------------------------------------------------");
        $display(" Time(ns) | rst |       pc       |    pc_plus4    |    pc_next     ");
        $display("----------------------------------------------------------------------");
        $monitor("   %4t   |  %b  |   0x%08h   |   0x%08h   |   0x%08h   ",
                 $time, rst, pc, pc_plus4, pc_next);

        // Initial state: Assert Reset
        clk = 0;
        rst = 1;
        pc_next = 32'h00000000;

        // Hold reset for 2 clock periods (20ns)
        #20;
        rst = 0;

        // Simulate 5 normal sequential clock cycles (PC increments by 4)
        repeat (5) begin
            @(posedge clk);
            #1; // small delay after clock edge
            pc_next = pc_plus4;
        end

        // Simulate a Jump / Branch (force PC to jump to 0x00000100)
        @(posedge clk);
        #1;
        pc_next = 32'h00000100;

        // Resume sequential counting after the branch
        repeat (3) begin
            @(posedge clk);
            #1;
            pc_next = pc_plus4;
        end

        #20;
        $display("----------------------------------------------------------------------");
        $display("SUCCESS: Testbench completed successfully!");
        $finish;
    end

endmodule