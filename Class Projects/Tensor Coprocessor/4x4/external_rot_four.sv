`include "internal_rot_four.sv"

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


module external_rotation_four(input [31:0] A,
                              input [31:0] B,
                              input [31:0] C,
                              input [31:0] D,
                              input [31:0] B11,
                              input [31:0] B12,
                              input [31:0] B13,
                              input [31:0] B14,
                              input [31:0] B21,
                              input [31:0] B22,
                              input [31:0] B23,
                              input [31:0] B24,
                              input [31:0] B31,
                              input [31:0] B32,
                              input [31:0] B33,
                              input [31:0] B34,
                              input [31:0] B41,
                              input [31:0] B42,
                              input [31:0] B43,
                              input [31:0] B44,
                              output [31:0] out1,
                              output [31:0] out2,
                              output [31:0] out3,
                              output [31:0] out4,
                              input clk, 
                              input start,
                              input rst,
                              output done);
  
  //Two done signals, one for each internal rotator
  wire done1;
  wire done2;
  wire done3;
  wire done4;
  
  //State of rotation held here
  reg [4:0] count;
  //states
  //0 == nothing / start
  //1 == start
  //2 == blank
  //3 == wait for outputs
  //4 == swap inputs / start
  //5 == start
  //6 == blank
  //7 == wait for outputs / done
  //8 == start
  //9 == start
  //A == blank
  //B == wait for outputs
  //C == swap inputs / start
  //D == start
  //E == blank
  //F == wait for outputs / done
  
  
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
    else if (count[3] || count[2] || count[1] || count[0]) begin
      if (!count[1]) begin
        count <= count + 1;
      end
      else begin
        if (!count[0]) begin
          count <= count + 1;
        end
        else if (done1 && done2 && done3 && done4) begin
          count <= count + 1;
        end
      end
    end
  end
  
  //first rotator
  //Note that this rotator starts with A, then swaps with B
  //Ideally, I'd like the internal rotators to rotate A matrix values among themselves instead of using a mux, but I ran out of time
  internal_rotation_four mult1(.A(count[3] ? count[2] ? B : C : count[2] ? D : A), .I(B11), .J(B41), .K(B31), .L(B21), .out(out1), .clk(clk), .start(!count[1]), .rst(rst), .done(done1), .count(count));
  
  //second rotator
  //Note that this rotator starts with B, then swaps with A
  //Also note that J and L start swapped because this rotator starts with B
  internal_rotation_four mult2(.A(count[3] ? count[2] ? C : D : count[2] ? A : B), .I(B22), .J(B12), .K(B42), .L(B32), .out(out2), .clk(clk), .start(!count[1]), .rst(rst), .done(done2), .count(count));
  
  //Third rotator
  //Note that this rotator starts with B, then swaps with A
  //Also note that J and L start swapped because this rotator starts with B
  internal_rotation_four mult3(.A(count[3] ? count[2] ? D : A : count[2] ? B : C), .I(B33), .J(B23), .K(B13), .L(B43), .out(out3), .clk(clk), .start(!count[1]), .rst(rst), .done(done3), .count(count));
  
  
  //Fourth rotator
  //Note that this rotator starts with B, then swaps with A
  //Also note that J and L start swapped because this rotator starts with B
  internal_rotation_four mult4(.A(count[3] ? count[2] ? A : B : count[2] ? C : D), .I(B44), .J(B34), .K(B24), .L(B14), .out(out4), .clk(clk), .start(!count[1]), .rst(rst), .done(done4), .count(count));
  
  
  //signal that a batch is done
  assign done = count[4];
  
endmodule