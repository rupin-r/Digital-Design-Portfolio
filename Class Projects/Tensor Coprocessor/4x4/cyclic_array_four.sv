`include "external_rot_four.sv"

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

module cyclic_array_four(input [31:0] A11,
                         input [31:0] A12,
                         input [31:0] A13,
                         input [31:0] A14,
                         input [31:0] A21,
                         input [31:0] A22,
                         input [31:0] A23,
                         input [31:0] A24,
                         input [31:0] A31,
                         input [31:0] A32,
                         input [31:0] A33,
                         input [31:0] A34,
                         input [31:0] A41,
                         input [31:0] A42,
                         input [31:0] A43,
                         input [31:0] A44,
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
                         output [31:0] out11,
                         output [31:0] out12,
                         output [31:0] out13,
                         output [31:0] out14,
                         output [31:0] out21,
                         output [31:0] out22,
                         output [31:0] out23,
                         output [31:0] out24,
                         output [31:0] out31,
                         output [31:0] out32,
                         output [31:0] out33,
                         output [31:0] out34,
                         output [31:0] out41,
                         output [31:0] out42,
                         output [31:0] out43,
                         output [31:0] out44,
                         input clk, 
                         input start, 
                         input rst,
                         output done);
  
  //Ignore the naming of this wire, it's for determining when the first batch is complete
  //so I wanted to use done, but it's in the portlist
  wire done1;
  
  //A counter that mainly holds the state
  //It's also used to trigger the start bits of the rotators
  reg [4:0] count;
  
  //states
  //00 == nothing
  //01 == start hold
  //02 == start hold
  //03 == wait for results
  //04 == store results
  //05 == store results
  //06 == reset
  //07 == blank
  //08 == blank
  //09 == start hold
  //0A == start hold
  //0B == wait for results
  //0C == store results
  //0D == store results
  //0E == reset
  //0F == blank
  //10 == blank
  //11 == start hold
  //12 == start hold
  //13 == wait for results
  //14 == store results
  //15 == store results
  //16 == reset
  //17 == blank
  //18 == blank
  //19 == start hold
  //1A == start hold
  //1B == wait for results
  //1C == store results
  //1D == done

  reg [31:0] outputC11, outputC12, outputC13, outputC14;
  reg [31:0] outputC21, outputC22, outputC23, outputC24;
  reg [31:0] outputC31, outputC32, outputC33, outputC34;
  reg [31:0] outputC41, outputC42, outputC43, outputC44;

  //Holds the output values of each accumulator
  wire [31:0] output_A;
  wire [31:0] output_B;
  wire [31:0] output_C;
  wire [31:0] output_D;
  
  //loop logic
  always_ff @(posedge clk, posedge rst) begin
    //reset just clears all the registers to 0
    if (rst) begin
      count <= 0;
      outputC11 <= 0;
      outputC12 <= 0;
      outputC13 <= 0;
      outputC14 <= 0;
      outputC21 <= 0;
      outputC22 <= 0;
      outputC23 <= 0;
      outputC24 <= 0;
      outputC31 <= 0;
      outputC32 <= 0;
      outputC33 <= 0;
      outputC34 <= 0;
      outputC41 <= 0;
      outputC42 <= 0;
      outputC43 <= 0;
      outputC44 <= 0;
    end
    else begin
      if (done) begin
        count <= 29;
      end
      else if (start) begin
        count <= 1;
      end
      else if (count[0] || count[1] || count[2] || count[3] || count[4]) begin
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
      if (!count[2] && count[1] && count[0] && done1) begin
        if (!count[4] && !count[3]) begin
          outputC11 <= output_A;
          outputC12 <= output_B;
          outputC13 <= output_C;
          outputC14 <= output_D;
        end
        if (!count[4] && count[3]) begin
          outputC21 <= output_A;
          outputC22 <= output_B;
          outputC23 <= output_C;
          outputC24 <= output_D;
        end
        if (count[4] && !count[3]) begin
          outputC31 <= output_A;
          outputC32 <= output_B;
          outputC33 <= output_C;
          outputC34 <= output_D;
        end
        if (count[4] && count[3]) begin
          outputC41 <= output_A;
          outputC42 <= output_B;
          outputC43 <= output_C;
          outputC44 <= output_D;
        end
      end
    end
  end
  
  //Call the outer shell of the matrix multiplier
  //This handles swapping A11 and A12 with A21 and A22 for batch changing
  external_rotation_four ex1(.A(count[4] ? count[3] ? A41 : A31 : count[3] ? A21 : A11), .B(count[4] ? count[3] ? A42 : A32 : count[3] ? A22 : A12), .C(count[4] ? count[3] ? A43 : A33 : count[3] ? A23 : A13), .D(count[4] ? count[3] ? A44 : A34 : count[3] ? A24 : A14), .B11(B11), .B12(B12), .B13(B13), .B14(B14), .B21(B21), .B22(B22), .B23(B23), .B24(B24), .B31(B31), .B32(B32), .B33(B33), .B34(B34), .B41(B41), .B42(B42), .B43(B43), .B44(B44),  .out1(output_A), .out2(output_B), .out3(output_C), .out4(output_D), .clk(clk), .start(!count[2] && (count[0] ^ count[1])), .rst((count[0] && count[1] && count[2]) || rst), .done(done1));
  
  //Assigning outputs based on the flag and reset timing
  //This holds the first batch and will be ready early
  assign out11 = outputC11;
  assign out12 = outputC12;
  assign out13 = outputC13;
  assign out14 = outputC14;
  assign out21 = outputC21;
  assign out22 = outputC22;
  assign out23 = outputC23;
  assign out24 = outputC24;
  assign out31 = outputC31;
  assign out32 = outputC32;
  assign out33 = outputC33;
  assign out34 = outputC34;
  assign out41 = outputC41;
  assign out42 = outputC42;
  assign out43 = outputC43;
  assign out44 = outputC44;

  //Output flag
  assign done = count[4] && count[3] && count[2] && count[0];
  
endmodule