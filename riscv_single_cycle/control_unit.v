module control_unit (
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    output reg reg_write,
    output reg [3:0] alu_control
);
    
always @(*) begin
    //default
    reg_write   = 1'b0;
    alu_control = 4'b0000;
    if (opcode == 7'b0110011) begin
        reg_write = 1'b1;
        case (func3)
            3'b000: begin
                if (func7[5] == 1'b1)
                    alu_control = 4'b0110; // SUB
                else
                    alu_control = 4'b0010; // ADD
            end

            3'b010:  alu_control = 4'b0111; // SLT
            3'b100:  alu_control = 4'b0011; // XOR
            3'b110:  alu_control = 4'b0001; // OR
            3'b111:  alu_control = 4'b0000; // AND
            default: alu_control = 4'b0000;
        endcase
    end
end

endmodule