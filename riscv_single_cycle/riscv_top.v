module riscv_top (
    input clk,rst
);
    // 1. PC wires
    wire [31:0] pc;
    wire [31:0] pc_next;
    wire [31:0] pc_plus4;
    // 2. Instruction wires
    wire [31:0] instruction;
    // 3. Decoder wires
    wire [6:0] opcode;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] func3;
    wire [6:0] func7;
    // 4. Control wires
    wire reg_write;
    wire [3:0] alu_control;
    // 5. Register File & ALU wires
    wire [31:0] read_data1, read_data2;
    wire [31:0] alu_result;
    wire zero;
    // For R-type instructions (no branches/jumps yet), PC always advances by +4
    assign pc_next = pc_plus4;

    program_counter u_pc (
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc(pc)
    );

    pc_adder u_pc_adder (
        .pc(pc),
        .pc_plus4(pc_plus4)
    );

    instruction_memory u_imem (
        .pc(pc),
        .instruction(instruction)
    );

    decoder u_decoder (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .func3(func3),
        .func7(func7)
    );

    control_unit u_control (
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .reg_write(reg_write),
        .alu_control(alu_control)
    );

    register_file u_regfile (
        .clk(clk),
        .rst(rst),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(alu_result),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    alu u_alu (
        .a(read_data1),
        .b(read_data2),
        .alu_control(alu_control),
        .alu_result(alu_result),
        .zero(zero)
    );

endmodule