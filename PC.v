`timescale  1ns / 1ns

module PC(input [31:0] PC_in, output [31:0] PC_out, input clk, rst, pcWrite);
  always @(posedge clk, posedge rst) begin
    if (rst) PC_out <= 32'b0;
    else if (pcWrite) PC_out <= PC_in;
  end
endmodule
