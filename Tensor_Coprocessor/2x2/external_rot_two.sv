`include "internal_rot_two.sv"

/*
This module handles the external rotation of matrix multiplication with A matrix values

This module must be in sync with internal rotation since the A matrix rotates at the same time the B matrix rotates

The inputs for this module are as follows:
A:     A single 32 bit floating point value from matrix A
B:     A single 32 bit floating point value from matrix A

The entirety of matrix B is included here
I:     A single 32 bit floating point value from matrix B
J:     A single 32 bit floating point value from matrix B
K:     A single 32 bit floating point value from matrix B
L:     A single 32 bit floating point value from matrix B

A row output is given with output values
out1:  A single 32 bit floating point value denoting a matrix multiplication output
out2:  A single 32 bit floating point value denoting a matrix multiplication output

clk:   The system clk positive edge trigger
rst:   A combination of reset_mult from cyclic array and system rst, positive edge trigger
start: Comes from the overall design for reset synchronization
done:  Signifies when row of matrix multiplication is done for batch timing

*/


module external_rotation_two (input [31:0] A,
                              input [31:0] B,
                              input [31:0] I,
                              input [31:0] J,
                              input [31:0] K,
                              input [31:0] L,
                              output [31:0] out1,
                              output [31:0] out2,
                              input clk, 
                              input start,
                              input rst,
                              output done);
  
  //Two done signals, one for each internal rotator
  wire done1;
  wire done2;
  //State of rotation held here
  //This could be passed into the internal rotators to control timing, but I didn't feel like doing it
  reg [3:0] count;
  
  //loop logic
  always_ff @(posedge clk, posedge rst) begin
    //reset counter to 0
    if (rst) begin
      count <= 0;
    end
    //count only if external rotator says to
    else if (start) begin
      count <= 1;
    end
    else if (count[2] || count[1] || count[0]) begin
      if (!count[1]) begin
        count <= count + 1;
      end
      else begin
        if (!count[0]) begin
          count <= count + 1;
        end
        else if (done1 && done2) begin
          count <= count + 1;
        end
      end
    end
  end
  
  //first rotator
  //Note that this rotator starts with A, then swaps with B
  //Ideally, I'd like the internal rotators to rotate A matrix values among themselves instead of using a mux, but I ran out of time
  internal_rotation_two mult1(.A(count[2] ? B : A), .I(I), .J(K), .out(out1), .clk(clk), .start(!count[1]), .rst(rst), .done(done1), .count(count));
  
  //second rotator
  //Note that this rotator starts with B, then swaps with A
  //Also note that J and L start swapped because this rotator starts with B
  internal_rotation_two mult2(.A(count[2] ? A : B), .I(L), .J(J), .out(out2), .clk(clk), .start(!count[1]), .rst(rst), .done(done2), .count(count));
  
  //signal that a batch is done
  assign done = count[3];
  
endmodule