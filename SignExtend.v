module SIGN_EXTEND #(parameter N = 16)(
    input [N-1:0] In,
    output [31:0] Out
);
    reg [31:0] z = 32'b0;
    reg [31:0] o = 32'b1;
    assign Out = {(In[N-1]==1)?o[31-N:0]:z[31-N:0], In};

endmodule
