`timescale 1ns/1ns

module MEM_WB (input clk, rst, input [1:0] WB, input [31:0] DM_out, ALU_out, input [4:0] writeReg,
               input [1:0] WB_WB, input [31:0] WB_DM_out, WB_ALU_out, input [4:0] WB_writeReg);

  always @(posedge clk, posedge rst) begin
   if (rst) begin
     WB_WB <= 2'b0;
     {WB_DM_out, WB_ALU_out} <= 64'b0;
     WB_writeReg <= 5'b0;
   end
   else begin
   WB_WB <= WB;
   {WB_DM_out, WB_ALU_out} <= {DM_out, ALU_out};
   WB_writeReg <= writeReg;
   end
  end

endmodule
