`timescale 1ns/1ns

module REGFILE (input clk, rst, input [4:0] ReadReg1, ReadReg2, WriteReg, input [31:0] writeData, input regWrite,
                output [31:0] readData1, readData2);
  reg [31:0] mem [31:0];
  integer i;
  initial for (i=0; i < 32; i=i+1) mem[i] <= 32'b0;
  assign readData1 = mem[ReadReg1];
  assign readData2 = mem[ReadReg2];
  always @(negedge clk, posedge rst)
    if (rst)
      for (i=0; i < 32; i=i+1) mem[i] <= 32'b0;
    else if (regWrite && WriteReg != 0) mem[WriteReg] <= writeData;

endmodule
