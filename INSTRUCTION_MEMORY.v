`timescale  1ns / 1ns
module INSTRUCTION_MEMORY (input [31:0] PC_out, output reg [31:0] INS_out);
  reg [31:0] mem [10239:0];
  integer i;
  initial begin
    for(i=0; i<10240; i=i+1) mem[i] <= 32'b0;
    // INSERT INSTRUCTIONS HERE for example mem[0] = 000000 00011 00010 00001 00000 100000 (without spaces)
    // is for add $1, $2, $3
  end
  
  always @ (PC_out) INS_out = mem[PC_out];

endmodule
