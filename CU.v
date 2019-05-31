`timescale 1ns/1ns

module CU(input clk, rst, output reg pcSrc, pcWrite, memRead, memWrite, ifidWrite, regDst,
          output reg [2:0] ALUop, output reg ALUsrc, output reg [1:0]forwardA, forwardB,
          output reg regWrite, stall_needed, ifidFlush, memToReg, jORb,
          input regs_equal, input [31:0] INS,input [4:0] EX_rs, EX_rt, MEM_writeReg, WB_writeReg,
          input [1:0] MEM_W, WB_W, EX_M);


parameter R_TYPE = 6'b0, LW = 6'b100011, SW = 6'b101011, J = 6'b000010, BEQ = 6'b000100, BNE = 6'b000101;
parameter ADD = 6'b1000000, SUB = 6'b100010, AND = 6'b100100, OR = 6'b100101, SLT = 6'b101010;

always @ (INS) begin
  {pcSrc, memRead, memWrite, regDst, ALUop, ALUsrc, regWrite, memToReg, jORb} <= 0;

  case(INS[31:26])
    R_TYPE: begin
      pcSrc <= 0;
      ALUsrc <= 0;
      regDst <= 1;
      memToReg <= 1;
      regWrite <= 1;
      case(INS[5:0])
        ADD: ALUop <= 0;
        SUB: ALUop <= 1;
        AND: ALUop <= 2;
        OR:  ALUop <= 3;
        SLT: ALUop <= 4;
      endcase
    end
    LW: begin
      pcSrc <= 0;
      ALUsrc <= 1;
      ALUop <= 0;
      regDst <= 0;
      memRead <= 1;
      memToReg <= 0;
      regWrite <= 1;
    end
    SW: begin
      pcSrc <= 0;
      ALUsrc <= 1;
      ALUop <= 0;
      memWrite <= 1;
    end
    J: begin
    pcSrc <= 1;
    jORb <= 0;
    end
    BEQ: begin
    pcSrc <= regs_equal;
    jORb <= 1;
    end
    BNE: begin
    pcSrc <= ~regs_equal;
    jORb <= 1;
    end
  endcase

end



always @ ( * ) begin
  forwardA <= (MEM_W[0] && EX_rs == MEM_writeReg && EX_rs != 0)?2:(WB_W[0] && EX_rs == WB_writeReg && EX_rs != 0)?1:0;
  forwardB <= (MEM_W[0] && EX_rt == MEM_writeReg && EX_rt != 0)?2:(WB_W[0] && EX_rt == WB_writeReg && EX_rt != 0)?1:0;
end

always @ ( * ) begin
  if (EX_M[0] && EX_rt != 0 && (EX_rt == INS[25:21] || EX_rt == INS[20:16]))
  {pcWrite, ifidWrite, stall_needed} <= 3'b001;
  else {pcWrite, ifidWrite, stall_needed} <= 3'b110;
end

always @ ( * ) begin
  case(INS[31:26])
    BEQ: ifidFlush <= regs_equal;
    BNE: ifidFlush <= ~regs_equal;
    default: ifidFlush <= 0;
  endcase

end

endmodule
