`timescale 1ns/1ns

module ALU (input [31:0] A, B, input [2:0] ALUop, output [31:0] OUT);
  parameter ADD = 0, SUB = 1, AND = 2, OR = 3, SLT = 4;
  case(ALUop):
    ADD: assign OUT = A + B;
    SUB: assign OUT = A - B;
    AND: assign OUT = A & B;
    OR : assign OUT = A | B;
    SLT: assign OUT = (A == B);

endmodule
