module top(clk1, clk2, in1, out1);
  input clk1, clk2, in1;
  output out1;
  wire w1;

  // Assuming DFF_X1 is a standard D-flip-flop cell in nangate45.lib
  // DFF_X1 instance_name (.D(data_in), .CK(clock_in), .Q(data_out));
  DFF_X1 dff1_instance (.D(in1), .CK(clk1), .Q(w1));
  DFF_X1 dff2_instance (.D(w1), .CK(clk2), .Q(out1));
endmodule 