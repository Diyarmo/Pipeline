module DATA_MEMORY(
    input clk, rst,
    input MemRead, MemWrite,
    input [31:0] Address, WriteVal,
    output reg [31:0] Out
);

    reg [31:0] mem [10239:0];

    always @(negedge clk) if(MemRead) Out <= mem[Address];
    integer i;
    always @(posedge clk, posedge rst) begin
        if(rst) for(i=0; i<10240; i=i+1) mem[i] <= 32'b0;
        else if(MemWrite) mem[Address] <= WriteVal;
    end

endmodule
