`timescale 1ns/1ns

module ALU (input [31:0] A, B, input [2:0] ALUop, output reg [31:0] OUT);
  parameter ADD = 0, SUB = 1, AND = 2, OR = 3, SLT = 4;
  always @(A, B, ALUop) begin
    case(ALUop)
      ADD: OUT = A + B;
      SUB: OUT = A - B;
      AND: OUT = A & B;
      OR : OUT = A | B;
      SLT: OUT = (A == B);
    endcase
  end
endmodule
