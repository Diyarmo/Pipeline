`timescale 1ns/1ns

module TB();

reg clk, rst; 
wire pcSrc, pcWrite, memRead, memWrite, ifidWrite, regDst, ALUsrc;
wire [2:0] ALUop;
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
          
 always #5 clk = ~clk;
  initial begin
    clk = 0;
    rst = 1;
    #20 rst = 0;
    
  end

endmodule
