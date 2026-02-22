`include "mult.sv"

/*
This module handles the inner rotation of matrix multiplication with B matrix values

This module must be in sync with external rotation since the A matrix rotates at the same time the B matrix rotates

The inputs for this module are as follows:
A:     A single 32 bit floating point value from matrix A

I:     A single 32 bit floating point value from matrix B
J:     A single 32 bit floating point value from matrix B

out:   A single 32 bit floating point value denoting a matrix multiplication output

clk:   The system clk positive edge trigger
rst:   A combination of reset_mult from cyclic array and system rst, positive edge trigger
start: Comes from the external rotator for synchronization
done:  Signifies when a single multiplication is done for rotation timing
*/

module internal_rotation_two (input [31:0] A,
                              input [31:0] I,
                              input [31:0] J,
                              output [31:0] out,
                              input [3:0] count,
                              input clk, 
                              input start, 
                              input rst,
                              output done);
  
  //just for debugging, not actually necessary
  wire [31:0] mult_out;
  //controls the internal swapping of B matrix values
  //reg [2:0] count;
  
  //loop logic
  //always_ff @(posedge clk, posedge rst) begin
    //reset counter to 0
    //if (rst) begin
      //count <= 0;
    //end
    //count only if external rotator says to
    //else if (start) begin
      //count <= 1;
    //end
    //else if (count[2] || count[1] || count[0]) begin
      //if (!count[1]) begin
        //count <= count + 1;
      //end
      //else begin
        //if (!count[0]) begin
          //count <= count + 1;
        //end
        //else if (done) begin
          //count <= count + 1;
        //end
      //end
    //end
  //end
  
  //multiply values swapping I and J based on the counter
  //the reason for xor is because count[0] must only be held high for one clock cycle
  //so the first batch can be signified as count = 01 and count = 10 after incrementing
  //and the second batch as count = 11 and count = 00 after incrementing
  //the difference between these two can be determined in a single bit with xor
  multiply mult(.A(A), .B(count[2] ? J : I), .out(mult_out), .out2(out), .clk(clk), .start(start), .rst(rst), .done(done));
  
endmodule