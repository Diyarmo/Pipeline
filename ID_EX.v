`timescale 1ns/1ns

module ID_EX (input clk, rst, input [1:0] WB, M, input [4:0] EX, input [31:0] readData1, readData2,
              S_EXTEND_out_b, input [4:0] rs, rt, rd, output reg [1:0] EX_WB, EX_M, output reg [4:0] EX_EX,
              output reg [31:0] EX_SRC_A, EX_SRC_B, EX_SE, output reg [4:0] EX_rs, EX_rt, EX_rd);
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      {EX_WB, EX_M, EX_EX} <= 9'b0;
      {EX_SRC_A, EX_SRC_B, EX_SE} <= 96'b0;
      {EX_rs, EX_rt, EX_rd} <= 15'b0;
    end
    else begin
    {EX_WB, EX_M, EX_EX} <= {WB, M, EX};
    {EX_SRC_A, EX_SRC_B, EX_SE} <= {readData1, readData2, S_EXTEND_out_b};
    {EX_rs, EX_rt, EX_rd} <= {rs, rt, rd};
    end
  end

endmodule
