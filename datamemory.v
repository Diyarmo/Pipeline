module DATA_MEMORY(
    input clk, rst,
    input MemRead, MemWrite,
    input [31:0] Address, WriteVal,
    output reg [31:0] Out
);

    reg [31:0] mem [10239:0];

    always @(negedge clk) if(MemRead) Out <= mem[Address];
    integer i;
    initial begin
      for(i=0; i<10240; i=i+1) mem[i] = 32'b0;
      mem[900] = 1000;
      mem[901] = 1004;
      mem[902] = 1;
      mem[1000] = 5;
      mem[1001] = 4;
      mem[1002] = 6;
      mem[1003] = 12;
      mem[1004] = 1;
    end
    always @(posedge clk) begin
        if(MemWrite) mem[Address] <= WriteVal;
    end

endmodule
