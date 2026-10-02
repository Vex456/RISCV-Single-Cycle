module decoder (
    input [31:0] instruction,
    output [6:0] opcode,
    output [4:0] rd, rs1, rs2,
    output [2:0] func3,
    output [6:0] func7
);

assign opcode = instruction[6:0];
assign rd = instruction[11:7];
assign func3 = instruction[14:12];
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign func7 = instruction[31:25];

endmodule