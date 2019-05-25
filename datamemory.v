module DATA_MEMORY(
    input clk, rst,
    input MemRead, MemWrite,
    input [31:0] Address, WriteVal,
    output reg [31:0] Out
);

    reg [31:0] Mem [0:16383];

    always @(negedge clk) if(MemRead) Out <= Mem[Address];

    always @(posedge clk, posedge rst) begin
        if(rst) Mem <= 524288'b0;
        else if(MemWrite) Mem[Address] <= WriteVal;
    end

endmodule
