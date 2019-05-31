`timescale 1ns/1ns

module TB();

wire clk, rst, pcSrc, pcWrite, memRead, memWrite, ifidWrite, regDst;
wire [2:0] ALUop, ALUsrc;
wire [1:0] forwardA, forwardB;
wire regWrite, stall_needed, ifidFlush, memToReg, jORb, regs_equal;
wire [31:0] INS; 
wire [4:0] EX_rs, EX_rt, MEM_writeReg, WB_writeReg;
wire [1:0] MEM_W, WB_W, EX_M;


CU cu(clk, rst, pcSrc, pcWrite, memRead, memWrite, ifidWrite, regDst,
          ALUop, ALUsrc, forwardA, forwardB,
          regWrite, stall_needed, ifidFlush, memToReg, jORb,
          regs_equal, INS, EX_rs, EX_rt, MEM_writeReg, WB_writeReg, MEM_W, WB_W, EX_M);
DP dp(clk, rst, pcSrc, pcWrite, memRead, memWrite, ifidWrite, regDst,
          ALUop, ALUsrc, forwardA, forwardB,
          regWrite, stall_needed, ifidFlush, memToReg, jORb,
          regs_equal, INS, EX_rs, EX_rt, MEM_writeReg, WB_writeReg, MEM_W, WB_W, EX_M);

endmodule
