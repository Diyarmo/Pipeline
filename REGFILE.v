`timescale 1ns/1ns

module REGFILE (input clk, rst, input [4:0] ReadReg1, ReadReg2, WriteReg, input [31:0] writeData, input regWrite,
                output reg [31:0] readData1, readData2);
  reg [31:0] mem [31:0];
  initial begin
    mem = 1024'b0;
  end
  always @(negedge clk) begin
    readData1 <= mem[ReadReg1];
    readData2 <= mem[ReadReg2];
  end
  always @(posedge clk, posedge rst)
    if (rst)
      mem = 1024'b0;
    else if (regWrite) mem[WriteReg] <= writeData;

endmodule
