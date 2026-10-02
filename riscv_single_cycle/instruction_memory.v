module instruction_memory (
    input [31:0] pc,
    output [31:0] instruction
);
reg [31:0] memory [0:1023];

//load instruction machine codes into memory
initial begin
    $readmemh("program.hex", memory);
end

// as my program counter is incrementing by + 4 i need to handle that 
// indexing is 0 1 2 3 4 and adress 0 4 8 12 diffrence factor is 4
// left shift by 2 is divided by 4 
// insted if leftshifting we slice

assign instruction = memory[pc[31:2]];
endmodule