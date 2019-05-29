`timescale 1ns/1ns

module DP(input clk, rst, pcSrc, pcWrite, memRead, memWrite, ifidWrite, regDst,
          input [2:0] ALUop, input ALUsrc, input [2:0]forwardA, [2:0]forwardB,
          input regWrite, stall_needed, ifidFlush, memToReg, jORb,
          output regs_equal);
wire [1:0] WB_WB;
wire [31:0] PC_in, PC_out, brAdd, new_PC, INS_out, jumpAdd, ID_PC;
assign new_PC = PC_out + 4;
PC pc(clk, rst, PC_in, PC_out, pcWrite);
INSTRUCTION_MEMORY im(PC_out, INS_out);

IF_ID ifid(clk, rst, ifidWrite, ifidFlush, INS_out, new_PC, ID_INS, ID_PC);

wire [4:0] writeReg;
wire [31:0] readData1, readData2, writeData, S_EXTEND_out_b, S_EXTEND_out_j, jbPC;
REGFILE rf(clk, rst, INS_out[25:21], INS_out[20:16], writeReg, writeData, WB_WB[0], readData1, readData2);
SIGN_EXTEND #(16)se1(INS_out[15:0], S_EXTEND_out_b);
assign brAdd = (S_EXTEND_out_b<<2) + ID_PC;
SIGN_EXTEND #(26)se2(INS_out[25:0], S_EXTEND_out_j);
wire  [31:0] shift_out_j;
assign shift_out_j = S_EXTEND_out_j << 2;  
assign jumpAdd = {ID_PC[31:28], shift_out_j[27:0]};
assign jbPC = (jORb==1)?brAdd:(jORb==0)?jumpAdd:32'bz;
assign PC_in =(pcSrc==1)?(new_PC):(pcSrc==0)?jbPC:32'bz;

COMPARATOR comp(readData1, readData2, regs_equal);
assign {WBmemToReg, WBregWrite, MpcSrc, MmemWrite, MmemRead, EXALUsrc, EXALUop, EXregDst} =
       (stall_needed==0)? {memToReg, regWrite, pcSrc, memWrite, memRead, ALUsrc, ALUop, regDst}:
       (stall_needed==1)? 9'b0:9'bz;

wire [1:0] ID_WB, EX_WB;
assign ID_WB = {WBmemToReg, WBregWrite};
wire [1:0] ID_M, EX_M;
assign ID_M = {MmemWrite, MmemRead};
wire [4:0] ID_EX, EX_EX;
assign ID_EX = {EXALUsrc, EXALUop, EXregDst};
wire [31:0] IDEX_SRC_A, IDEX_SRC_B;
ID_EX idex(clk, rst, ID_WB, ID_M, ID_EX, readData1, readData2, S_EXTEND_out_b, INS_out[25:21], INS_out[20:16], INS_out[15:11],
           EX_WB, EX_M, EX_EX, IDEX_SRC_A, IDEX_SRC_B, IDEX_SE, IDEX_rs, IDEX_rt, IDEX_rd);

wire [31:0] ALU_A, ALU_B, ALU_C;
wire [31:0] MEM_ALU_out, WB_DM_out;
assign ALU_A = (forwardA==2)?MEM_ALU_out:(forwardA==1)?WB_DM_out:(forwardA==0)?IDEX_SRC_A:32'bz;
assign ALU_C = (forwardB==2)?MEM_ALU_out:(forwardB==1)?WB_DM_out:(forwardB==0)?IDEX_SRC_B:32'bz;
assign ALU_B = (EX_EX[3]==1)?IDEX_SE:(EX_EX[3]==0)?ALU_C:32'bz;
wire [31:0] ALU_OUT;
ALU alu(ALU_A, ALU_B, EX_EX[3:1], ALU_OUT);
assign EX_writeReg = (regDst==1)?IDEX_rd:(regDst==0)?IDEX_rt:5'bz;

wire [1:0] MEM_WB;
wire [1:0] MEM_M;
wire [31:0] DM_address, DM_Wdata, DM_out;
wire [4:0] MEM_writeReg;
EX_MEM exmem(clk, rst, EX_WB, EX_M, ALU_OUT, ALU_C, EX_writeReg,
             MEM_WB, MEM_M, MEM_ALU_out, DM_Wdata, MEM_writeReg);

DATA_MEMORY dm(clk, rst, MEM_M[1], MEM_M[0], DM_address, DM_Wdata, DM_out);


MEM_WB memwb(clk, rst, MEM_WB, DM_out, MEM_ALU_out, MEM_writeReg,
             WB_WB, WB_DM_out, WB_ALU_out, writeReg);

assign WB_writeReg = (WB_WB[1]==1)?WB_ALU_out:(WB_WB[1]==0)?WB_DM_out:5'bz;


endmodule
