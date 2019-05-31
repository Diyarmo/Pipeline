`timescale 1ns/1ns

module DP(input clk, rst, pcSrc, pcWrite, memRead, memWrite, ifidWrite, regDst,
          input [2:0] ALUop, input ALUsrc, input [1:0]forwardA, forwardB,
          input regWrite, stall_needed, ifidFlush, memToReg, jORb,
          output regs_equal, output [31:0] ID_INS, output [4:0] EX_rs, EX_rt, MEM_writeReg, WB_writeReg,
          output [1:0] MEM_W, WB_W, EX_M);
wire [31:0] PC_in, PC_out, brAdd, new_PC, INS_out, jumpAdd, ID_PC;
assign new_PC = PC_out + 4;
PC pc(clk, rst, PC_in, PC_out, pcWrite);
INSTRUCTION_MEMORY im(PC_out, INS_out);

IF_ID ifid(clk, rst, ifidWrite, ifidFlush, INS_out, new_PC, ID_INS, ID_PC);

wire [31:0] readData1, readData2, writeData, S_EXTEND_out_b, S_EXTEND_out_j, jbPC;
REGFILE rf(clk, rst, ID_INS[25:21], ID_INS[20:16], WB_writeReg, writeData, WB_W[0], readData1, readData2);
SIGN_EXTEND #(16)se1(ID_INS[15:0], S_EXTEND_out_b);
assign brAdd = S_EXTEND_out_b + ID_PC;
SIGN_EXTEND #(26)se2(ID_INS[25:0], S_EXTEND_out_j);
assign jumpAdd = {ID_PC[31:28], S_EXTEND_out_j[27:0]};
assign jbPC = (jORb==1)?brAdd:(jORb==0)?jumpAdd:32'bz;
assign PC_in =(pcSrc==1)?(new_PC):(pcSrc==0)?jbPC:32'bz;

COMPARATOR comp(readData1, readData2, regs_equal);
assign {WBmemToReg, WBregWrite, MpcSrc, MmemWrite, MmemRead, EXALUsrc, EXALUop, EXregDst} =
       (stall_needed==0)? {memToReg, regWrite, pcSrc, memWrite, memRead, ALUsrc, ALUop, regDst}:
       (stall_needed==1)? 9'b0:9'bz;

wire [1:0] ID_W, EX_W;
assign ID_W = {WBmemToReg, WBregWrite};
wire [1:0] ID_M;
assign ID_M = {MmemWrite, MmemRead};
wire [4:0] ID_E, EX_E;
assign ID_E = {EXALUsrc, EXALUop, EXregDst};
wire [31:0] EX_SRC_A, EX_SRC_B, EX_SE;
ID_E idex(clk, rst, ID_W, ID_M, ID_E, readData1, readData2, S_EXTEND_out_b, ID_INS[25:21], ID_INS[20:16], ID_INS[15:11],
           EX_W, EX_M, EX_E, EX_SRC_A, EX_SRC_B, EX_SE, EX_rs, EX_rt, EX_rd);

wire [31:0] ALU_A, ALU_B, ALU_C;
wire [31:0] MEM_ALU_out, WB_DM_out;
assign ALU_A = (forwardA==2)?MEM_ALU_out:(forwardA==1)?WB_DM_out:(forwardA==0)?EX_SRC_A:32'bz;
assign ALU_C = (forwardB==2)?MEM_ALU_out:(forwardB==1)?WB_DM_out:(forwardB==0)?EX_SRC_B:32'bz;
assign ALU_B = (EX_E[4]==1 )?EX_SE:(EX_E[4]==0)?ALU_C:32'bz;
wire [31:0] ALU_OUT;
ALU alu(ALU_A, ALU_B, EX_E[3:1], ALU_OUT);
assign EX_writeReg = (regDst==1)?EX_rd:(regDst==0)?EX_rt:5'bz;


wire [1:0] MEM_M;
wire [31:0] DM_address, DM_Wdata, DM_out;
EX_MEM exmem(clk, rst, EX_W, EX_M, ALU_OUT, ALU_C, EX_writeReg,
             MEM_W, MEM_M, MEM_ALU_out, DM_Wdata, MEM_writeReg);

DATA_MEMORY dm(clk, rst, MEM_M[1], MEM_M[0], DM_address, DM_Wdata, DM_out);


MEM_W memwb(clk, rst, MEM_W, DM_out, MEM_ALU_out, MEM_writeReg,
             WB_W, WB_DM_out, WB_ALU_out, WB_writeReg);

assign WB_writeReg = (WB_W[1]==1)?WB_ALU_out:(WB_W[1]==0)?WB_DM_out:5'bz;


endmodule
