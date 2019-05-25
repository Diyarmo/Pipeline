module COMPARATOR(
    input [31:0] In1, In2,
    output EQ
);
    assign EQ = (In1 == In2);
endmodule
