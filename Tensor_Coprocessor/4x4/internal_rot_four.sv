`include "mult.sv"

/*
This module handles the inner rotation of matrix multiplication with B matrix values

This module must be in sync with external rotation since the A matrix rotates at the same time the B matrix rotates

The inputs for this module are as follows:
A:     A single 32 bit floating point value from matrix A

I:     A single 32 bit floating point value from matrix B
J:     A single 32 bit floating point value from matrix B
K:     A single 32 bit floating point value from matrix B
L:     A single 32 bit floating point value from matrix B

out:   A single 32 bit floating point value denoting a matrix multiplication output

clk:   The system clk positive edge trigger
rst:   A combination of reset_mult from cyclic array and system rst, positive edge trigger
start: Comes from the external rotator for synchronization
done:  Signifies when a single multiplication is done for rotation timing
*/

module internal_rotation_four(input [31:0] A,
                              input [31:0] I,
                              input [31:0] J,
                              input [31:0] K,
                              input [31:0] L,
                              output [31:0] out,
                              input [4:0] count,
                              input clk, 
                              input start, 
                              input rst,
                              output done);
  
  //just for debugging, not actually necessary
  wire [31:0] mult_out;

  multiply mult(.A(A), .B(count[3] ? count[2] ? L : K : count[2] ? J : I), .out(mult_out), .out2(out), .clk(clk), .start(start), .rst(rst), .done(done));
  
endmodule
