`timescale 1ns/1ns
module DP(input clk, rst, pcSrc, pcWrite, memRead, memWrite, ifidWrite, regDst,
          input [1:0] ALUop, input ALUsrc, input [2:0]forwardA, [2:0]forwardB,
          input regs_equal, regWrite, stall_needed, ifidFlush, memToReg
          output regs_equal)؛

wire [31:0] PC_in, PC_out, jumpAdd, new_PC, INS_out;
assign new_PC = PC_out + 4;
PC pc(PC_in, PC_out, clk, rst, pcWrite);
INS_MEM im(PC_out, INS_out);

IF_ID ifid(ifidWrite, ifidFlush, INS_out, new_PC, IFID_INS, IFID_PC);

wire [4:0] writeReg;
wire [31:0] readData1, readData2, writeData, S_EXTEND_out;
REGFILE rf(INS_out[25:21], INS_out[20:16], writeReg, writeData, WB_WB[0], readData1, readData2);
S_EXTEND se(INS_out[15:0], S_EXTEND_out);
assign jumpAdd = (S_EXTEND_out<<2) + IFID_PC;
COMPARATOR comp(readData1, readData2, regs_equal);
assign {WBmemToReg, WBregWrite, MpcSrc, MmemWrite, MmemRead, EXALUsrc, EXALUop, EXregDst} =
       (stall_needed==0)? {memToReg, regWrite, pcSrc, memWrite, memRead, ALUsrc, ALUop, regDst}:
       (stall_needed==1)? 8'b0:8'bz;
wire [1:0] ID_WB = {WBmemToReg, WBregWrite}, EX_WB;
wire [2:0] ID_M = {MpcSrc, MmemWrite, MmemRead}, EX_M;
wire [3:0] ID_EX = {EXALUsrc, EXALUop, EXregDst}, EX_EX;

ID_EX idex(ID_WB, ID_M, ID_EX, readData1, readData2, S_EXTEND_out, INS_out[25:21], INS_out[20:16], INS_out[15:11],
           EX_WB, EX_M, EX_EX, IDEX_SRC_A, IDEX_SRC_B, IDEX_SE, IDEX_rs, IDEX_rt, IDEX_rd);

wire [31:0] ALU_A, ALU_B, ALU_C;
assign ALU_A = (forwardA==2)?MEM_ALU_out:(forwardA==1)?WB_DM_out:(forwardA==0)?IDEX_SRC_A:32'bz;
assign ALU_C = (forwardB==2)?MEM_ALU_out:(forwardB==1)?WB_DM_out:(forwardB==0)?IDEX_SRC_B:32'bz;
assign ALU_B = (EX_EX[3]==1)?IDEX_SE:(EX_EX[3]==0)?ALU_C:32'bz;
wire [31:0] ALU_OUT;
ALU alu(ALU_A, ALU_B, IDEX_EX[2:1], ALU_OUT);
assign EX_writeReg = (regDst==1)?IDEX_rd:(regDst==0)?IDEX_rt:5'bz;

wire [1:0] MEM_WB;
wire [2:0] MEM_M;
wire [31:0] DM_address, DM_Wdata, DM_out;
wire [4:0] MEM_writeReg;
EX_MEM exmem(EX_WB, EX_M, ALU_OUT, ALU_C, EX_writeReg
             MEM_WB, MEM_M, MEM_ALU_out, DM_Wdata, MEM_writeReg);

DATA_MEM dm(DM_address, DM_Wdata, MEM_M[1], MEM_M[0], DM_out);
assign PC_in =(MEM_M[2]==1)?(new_PC):(MEM_M[2]==0)?jumpAdd:8'bz;

wire [1:0] WB_WB;
MEM_WB memwb(MEM_WB, DM_out, MEM_ALU_out, MEM_writeReg,
             WB_WB, WB_DM_out, WB_ALU_out, writeReg);

assign WB_writeReg = (WB_WB[1]==1)?WB_ALU_out:(WB_WB[1]==0)?WB_DM_out:5'bz;


endmodule
