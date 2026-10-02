module alu (
    input [31:0] a, b,
    input [3:0] alu_control,
    output reg [31:0] alu_result,
    output zero
);

assign zero = (alu_result == 32'b0); 

always @(*) begin
    case (alu_control)
        4'b0000: alu_result = a & b; // AND
        4'b0001: alu_result = a | b; // OR
        4'b0010: alu_result = a + b; // ADD
        4'b0011: alu_result = a ^ b; //Xor
        4'b0110: alu_result = a - b; // SUB
        4'b0111: alu_result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLT (Signed)
        default: alu_result = 32'd0;
    endcase
end
endmodule
