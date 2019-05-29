`timescale 1ns / 1ns

module IF_ID (input clk, rst, ifidWrite, ifidFlush, input [31:0] INS_out, new_PC, output reg [31:0] IFID_INS, IFID_PC);
  always @(posedge clk, posedge rst) begin
    if (rst || ifidFlush) begin
      IFID_INS <= 32'b0;
      IFID_PC <= 32'b0;
    end
    else if (ifidWrite) begin
      IFID_INS <= INS_out;
      IFID_PC <= new_PC;
    end
  end

endmodule
