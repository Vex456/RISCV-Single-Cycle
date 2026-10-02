module register_file (
    input clk, rst, reg_write,
    input [4:0] rs1, rs2, rd,
    input [31:0] write_data,
    output [31:0] read_data1, read_data2
);

reg [31:0] registers [0:31];

assign read_data1 = (rs1 == 5'b0) ? 32'b0 :  registers[rs1];
assign read_data2 = (rs2 == 5'b0) ? 32'b0 :  registers[rs2];

integer i;
always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < 32; i = i +1) begin
            registers[i] <= 32'b0;
        end
    end
    else if (reg_write && (rd != 5'b0)) begin
        registers[rd] <= write_data;
    end
end

endmodule