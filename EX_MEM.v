`timescale 1ns/1ns

module EX_MEM (input clk, rst, input [1:0] WB, M, input [31:0] ALU_OUT, ALU_C, input [4:0] writeReg,
               output reg [1:0] MEM_WB, MEM_M, output reg [31:0] MEM_ALU_out, DM_Wdata, output reg [4:0] MEM_writeReg);

  always @(posedge clk, posedge rst) begin
   if (rst) begin
     {MEM_WB, MEM_M} <= 4'b0;
     {MEM_ALU_out, DM_Wdata} <= 64'b0;
     MEM_writeReg <= 5'b0;
   end
   else begin
   {MEM_WB, MEM_M} <= {WB, M};
   {MEM_ALU_out, DM_Wdata} <= {ALU_OUT, ALU_C};
   MEM_writeReg <= writeReg;
   end
  end

endmodule
