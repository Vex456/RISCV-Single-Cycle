`timescale 1ns / 1ps
`include "riscv_top.v"

module tb_top;

    reg clk;
    reg rst;

    // Instantiate Top-Level RISC-V Processor
    riscv_top dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Generate waveform file for GTKWave
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_top);

        clk = 0;
        rst = 1;

        $display("=======================================================================");
        $display("               RISC-V R-TYPE CORE SIMULATION RUN                       ");
        $display("=======================================================================");

        // Hold reset for 2 clock cycles
        #20;
        
        // Seed initial values in registers for R-type testing
        // x1 = 20, x2 = 5
        dut.u_regfile.registers[1] = 32'd20;
        dut.u_regfile.registers[2] = 32'd5;
        
        $display("Pre-seeded Registers: x1 = %0d, x2 = %0d", 
                 dut.u_regfile.registers[1], dut.u_regfile.registers[2]);
        $display("-----------------------------------------------------------------------");

        // Release reset
        rst = 0;

        // Cycle 1: add x3, x1, x2  -> x3 = 25
        @(posedge clk); #1;
        $display("Cycle 1 | PC: 0x%08h | Inst: 0x%08h | ALU Res: %0d | ADD -> x3 = %0d (Expected: 25)",
                 dut.pc, dut.instruction, dut.alu_result, dut.u_regfile.registers[3]);

        // Cycle 2: sub x4, x1, x2  -> x4 = 15
        @(posedge clk); #1;
        $display("Cycle 2 | PC: 0x%08h | Inst: 0x%08h | ALU Res: %0d | SUB -> x4 = %0d (Expected: 15)",
                 dut.pc, dut.instruction, dut.alu_result, dut.u_regfile.registers[4]);

        // Cycle 3: and x5, x1, x2  -> x5 = 4
        @(posedge clk); #1;
        $display("Cycle 3 | PC: 0x%08h | Inst: 0x%08h | ALU Res: %0d | AND -> x5 = %0d (Expected: 4)",
                 dut.pc, dut.instruction, dut.alu_result, dut.u_regfile.registers[5]);

        // Cycle 4: or  x6, x1, x2  -> x6 = 21
        @(posedge clk); #1;
        $display("Cycle 4 | PC: 0x%08h | Inst: 0x%08h | ALU Res: %0d | OR  -> x6 = %0d (Expected: 21)",
                 dut.pc, dut.instruction, dut.alu_result, dut.u_regfile.registers[6]);

        // Cycle 5: xor x7, x1, x2  -> x7 = 17
        @(posedge clk); #1;
        $display("Cycle 5 | PC: 0x%08h | Inst: 0x%08h | ALU Res: %0d | XOR -> x7 = %0d (Expected: 17)",
                 dut.pc, dut.instruction, dut.alu_result, dut.u_regfile.registers[7]);

        // Cycle 6: slt x8, x2, x1  -> x8 = 1 (5 < 20)
        @(posedge clk); #1;
        $display("Cycle 6 | PC: 0x%08h | Inst: 0x%08h | ALU Res: %0d | SLT -> x8 = %0d (Expected: 1)",
                 dut.pc, dut.instruction, dut.alu_result, dut.u_regfile.registers[8]);

        #10;
        $display("-----------------------------------------------------------------------");
        $display("Final Register Dump:");
        $display("x1 = %0d | x2 = %0d | x3 = %0d | x4 = %0d | x5 = %0d | x6 = %0d | x7 = %0d | x8 = %0d",
                 dut.u_regfile.registers[1], dut.u_regfile.registers[2],
                 dut.u_regfile.registers[3], dut.u_regfile.registers[4],
                 dut.u_regfile.registers[5], dut.u_regfile.registers[6],
                 dut.u_regfile.registers[7], dut.u_regfile.registers[8]);

        if (dut.u_regfile.registers[3] == 25 &&
            dut.u_regfile.registers[4] == 15 &&
            dut.u_regfile.registers[5] == 4  &&
            dut.u_regfile.registers[6] == 21 &&
            dut.u_regfile.registers[7] == 17 &&
            dut.u_regfile.registers[8] == 1) begin
            $display(">> ALL R-TYPE INSTRUCTIONS VERIFIED SUCCESSFULLY! <<");
        end else begin
            $display(">> VERIFICATION FAILED! <<");
        end
        $display("=======================================================================");
        $finish;
    end

endmodule