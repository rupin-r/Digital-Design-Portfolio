`timescale 10ns/100ps

module sign_extender(in, out);
  input [15:0] in;
  output [31:0] out;
  
  assign out = { {16{in[15:15]}}, in };
  
endmodule
  