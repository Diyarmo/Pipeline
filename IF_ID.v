`timescale 1ns / 1ns

module IF_ID (input clk, rst, ifidWrite, ifidFlush, input [31:0] INS_out, new_PC, output reg [31:0] ID_INS, ID_PC);
  always @(posedge clk, posedge rst) begin
    if (rst || ifidFlush) begin
      ID_INS <= 32'b0;
      ID_PC <= 32'b0;
    end
    else if (ifidWrite) begin
      ID_INS <= INS_out;
      ID_PC <= new_PC;
    end
  end

endmodule
