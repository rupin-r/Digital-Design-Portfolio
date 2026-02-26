`include "external_rot_two.sv"

/*
This module implements a 2x2 floating point matrix multiplier given full input and output port lists
It takes approximately 120 cycles to complete one 2x2 multiplication with held outputs

Approximately 27 cycles go into a single multiplication
25 cycles are for multiplication, one cycle for addition, and one for holding output
Then there are additional cycles used for resetting multipliers and sums

The matrix multiplication follows a cyclic array pattern to compute NxN matrix 
multiplication using N MAC units

The pattern is as follows:
Given arrays A = [ A11  A12 ] and B = [ B11  B12 ]
                 [ A21  A22 ]         [ B21  B22 ]

Then an output row can be computed with 2 MAC units and 2 rotations
First batch:
    Pass in A11 and A12 as well as the entirety of B
    MAC unit 1:
        Contains B11 and B21
    MAC unit 2:
        Contains B12 and B22
Second batch:
    Pass in A21 and A22 as well as the entirety of B
    MAC unit 1:
        Contains B11 and B21
    MAC unit 2:
        Contains B12 and B22 
    
Structure:
            A11       A12  
             |         |   
             V         V   
          [ B11 ]   [ B22 ]
          [ B21 ]   [ B12 ]

          [ A11 * B11 -> accumulator]  [ A12 * B22 -> accumulator ]
          [    B12                  ]  [    B21                   ]

           ROTATE
           Swap A11 and A12, then swap B11 with B21 and B22 with B12

            A12       A11  
             |         |   
             V         V   
          [ B21 ]   [ B12 ]
          [ B11 ]   [ B22 ]

          [ A12 * B21 -> accumulator]  [ A11 * B12 -> accumulator ]
          [    B11                  ]  [    B22                   ]

          The accumulators now hold the results for that row
          The next batch calculates the next row
          
          This pattern scales up for N MAC units with rotation instead of swapping


The inputs for this module are as follows:
Array 1: [ A  B ]
         [ C  D ]

Array 2: [ I  J ]
         [ K  L ]

Output:  [ out1 = AI + BK   out2 = AJ + BL ]
         [ out3 = CI + DK   out4 = CJ + DL ]

Additional note, out1 and out2 will be completed in half the time it takes to complete out3 and out4. These values will be held in out1 and out2 and can be used preemptively.

clk:   The system clk positive edge trigger. Should be relatively fast.
start: Should be held high for a maximum of two clock cycles, then set low
       I think I fixed it so that it doesn't really matter, but it should still 
       be less than 100 clock cycles or it will start causing errors
rst:   Positive edge triggered. Resets literally everything to 0
done:  An output bit that dictates when output values are ready to use
       This maintains the output values as well
       Because of this, you can not start another matrix multiplication without resetting
*/

module cyclic_array_two (input [31:0] A,
                         input [31:0] B,
                         input [31:0] C,
                         input [31:0] D,
                         input [31:0] I,
                         input [31:0] J,
                         input [31:0] K,
                         input [31:0] L,
                         output [31:0] out1,
                         output [31:0] out2,
                         output [31:0] out3,
                         output [31:0] out4,
                         input clk, 
                         input start, 
                         input rst,
                         output done);
  
  //Ignore the naming of this wire, it's for determining when the first batch is complete
  //so I wanted to use done, but it's in the portlist
  wire done1;
  
  //A counter that mainly holds the state
  //It's also used to trigger the start bits of the rotators
  reg [3:0] count;
  
  //states
  //0 == nothing
  //1 == start hold
  //2 == start hold
  //3 == wait for results
  //4 == store results
  //5 == store results
  //6 == reset
  //7 == blank
  //8 == blank
  //9 == start hold
  //A == start hold
  //B == store results
  //C-F == done

  reg [31:0] outputC1, outputC2, outputC3, outputC4;  

  //Holds the output values of each accumulator
  wire [31:0] output_A;
  wire [31:0] output_B;
  
  //loop logic
  always_ff @(posedge clk, posedge rst) begin
    //reset just clears all the registers to 0
    if (rst) begin
      count <= 0;
      outputC1 <= 0;
      outputC2 <= 0;
      outputC3 <= 0;
      outputC4 <= 0;
    end
    else begin
      if (done) begin
        count <= 13;
      end
      else if (start) begin
        count <= 1;
      end
      else if (count[0] || count[1] || count[2] || count[3]) begin
        if (!count[2] && (count[0] ^ count[1])) begin
          count <= count + 1;
        end
        else if (count[0] && count[1] && !count[2]) begin
          if (done1) begin
            count <= count + 1;
          end
        end
        else begin
          count <= count + 1;
        end
      end
      if (!rst && !count[3] && !count[2] && count[1] && count[0] && done1) begin
        outputC1 <= output_A;
        outputC2 <= output_B;
      end
      if (!rst && count[3] && !count[2] && count[1] && count[0] && done1) begin
        outputC3 <= output_A;
        outputC4 <= output_B;
      end
    end
  end
  
  //Call the outer shell of the matrix multiplier
  //This handles swapping A11 and A12 with A21 and A22 for batch changing
  external_rotation_two ex1(.A(count[3] ? C : A), .B(count[3] ? D : B), .I(I), .J(J), .K(K), .L(L), .out1(output_A), .out2(output_B), .clk(clk), .start(!count[2] && (count[0] ^ count[1])), .rst((count[0] && count[1] && count[2]) || rst), .done(done1));
  
  //Assigning outputs based on the flag and reset timing
  //This holds the first batch and will be ready early
  assign out1 = outputC1;
  assign out2 = outputC2;
  assign out3 = outputC3;
  assign out4 = outputC4;

  //Output flag
  assign done = count[3] && count[2] && count[0];
  
endmodule