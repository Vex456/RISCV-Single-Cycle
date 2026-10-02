`timescale 1ns / 1ps
`include "alu.v"

module tb_alu;
    reg  [31:0] a, b;
    reg  [3:0]  alu_control;
    wire [31:0] alu_result;
    wire        zero;

    alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .alu_result(alu_result),
        .zero(zero)
    );

    initial begin
        $display("==================================================");
        $display("              ALU VERIFICATION RUN                ");
        $display("==================================================");

        // 1. Test ADD (10 + 3 = 13)
        a = 32'd10; b = 32'd3; alu_control = 4'b0010; #10;
        $display("ADD (10 + 3)       -> Result: %0d (Expected: 13) | Zero: %b", alu_result, zero);

        // 2. Test SUB (10 - 3 = 7)
        a = 32'd10; b = 32'd3; alu_control = 4'b0110; #10;
        $display("SUB (10 - 3)       -> Result: %0d (Expected: 7)  | Zero: %b", alu_result, zero);

        // 3. Test SUB with Zero Flag (10 - 10 = 0)
        a = 32'd10; b = 32'd10; alu_control = 4'b0110; #10;
        $display("SUB (10 - 10)      -> Result: %0d (Expected: 0)  | Zero: %b (Expected: 1)", alu_result, zero);

        // 4. Test AND (10 & 3 = 2)
        a = 32'd10; b = 32'd3; alu_control = 4'b0000; #10;
        $display("AND (10 & 3)       -> Result: %0d (Expected: 2)  | Zero: %b", alu_result, zero);

        // 5. Test OR (10 | 3 = 11)
        a = 32'd10; b = 32'd3; alu_control = 4'b0001; #10;
        $display("OR  (10 | 3)       -> Result: %0d (Expected: 11) | Zero: %b", alu_result, zero);

        // 6. Test XOR (10 ^ 3 = 9)
        a = 32'd10; b = 32'd3; alu_control = 4'b0011; #10;
        $display("XOR (10 ^ 3)       -> Result: %0d (Expected: 9)  | Zero: %b", alu_result, zero);

        // 7. Test SLT (Positive numbers: 3 < 10 = 1)
        a = 32'd3; b = 32'd10; alu_control = 4'b0111; #10;
        $display("SLT (3 < 10)       -> Result: %0d (Expected: 1)  | Zero: %b", alu_result, zero);

        // 8. Test SLT (Signed negative numbers: -5 < 3 = 1)
        a = -32'd5; b = 32'd3; alu_control = 4'b0111; #10;
        $display("SLT (-5 < 3)       -> Result: %0d (Expected: 1)  | Zero: %b", alu_result, zero);

        $display("==================================================");
        $finish;
    end
endmodule