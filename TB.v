`timescale 1ns/1ns

module TB();

wire clk, rst, pcSrc, pcWrite, memRead, memWrite, ifidWrite, regDst,
          [2:0] ALUop, ALUsrc, [1:0] forwardA, forwardB,
          regWrite, stall_needed, ifidFlush, memToReg, jORb,
          regs_equal, [31:0] INS, [4:0] EX_rs, EX_rt, MEM_writeReg, WB_writeReg,
          [1:0] MEM_W, WB_W, EX_M);


CU cu(clk, rst, pcSrc, pcWrite, memRead, memWrite, ifidWrite, regDst,
          ALUop, output reg ALUsrc, forwardA, forwardB,
          regWrite, stall_needed, ifidFlush, memToReg, jORb,
          regs_equal, INS, EX_rs, EX_rt, MEM_writeReg, WB_writeReg, MEM_W, WB_W, EX_M);
DP dp(clk, rst, pcSrc, pcWrite, memRead, memWrite, ifidWrite, regDst,
          ALUop, output reg ALUsrc, forwardA, forwardB,
          regWrite, stall_needed, ifidFlush, memToReg, jORb,
          regs_equal, INS, EX_rs, EX_rt, MEM_writeReg, WB_writeReg, MEM_W, WB_W, EX_M);

endmodule
