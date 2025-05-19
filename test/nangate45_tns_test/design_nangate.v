module top (
    input clk,
    input reset,
    input in1,
    output out1
);

    wire n1, n2, n3, n4, n5;

    // Using Nangate45 cells
    DFF_X1 reg1_instance (
        .CK(clk),
        .D(in1),
        .Q(n1)
        // .QN() // Nangate DFF_X1 typically doesn't have QN by default, or it's named differently.
        // .RSTN(reset) // Or .S(set_signal), .R(reset_signal) depending on specific DFF type if reset is needed
    );

    INV_X1 inv1_instance (
        .A(n1),
        .ZN(n2) // Nangate INV_X1 typically uses ZN for output
    );

    DFF_X1 reg2_instance (
        .CK(clk),
        .D(n2),
        .Q(n3)
    );

    INV_X1 inv2_instance (
        .A(n3),
        .ZN(n4)
    );
    
    DFF_X1 reg3_instance (
        .CK(clk),
        .D(n4),
        .Q(n5)
    );

    // Using a buffer for the output, also from Nangate45
    BUF_X1 out_buf_instance (
        .A(n5),
        .Z(out1) // Nangate BUF_X1 typically uses Z for output
    );

endmodule 