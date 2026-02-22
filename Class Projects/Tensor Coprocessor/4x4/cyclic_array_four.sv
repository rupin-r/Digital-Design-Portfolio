`include "external_rot_four.sv"

/*
This module implements a 4x4 floating point matrix multiplier given full input and output port lists
It takes approximately 480 cycles to complete one 2x2 multiplication with held outputs

Approximately 27 cycles go into a single multiplication
25 cycles are for multiplication, one cycle for addition, and one for holding output
Then there are additional cycles used for resetting multipliers and sums

The matrix multiplication follows a cyclic array pattern to compute NxN matrix 
multiplication using N MAC units

The pattern is as follows:
Given arrays A = [ A11  A12  A13  A14 ] and B = [ B11  B12  B13  B14 ]
                 [ A21  A22  A23  A24 ]         [ B21  B22  B23  B24 ]
                 [ A31  A32  A33  A34 ]         [ B31  B32  B33  B34 ]
                 [ A41  A42  A43  A44 ]         [ B41  B42  B43  B44 ]

Then an output row can be computed with 4 MAC units and 4 rotations
First batch:
    Pass in A11, A12, A13, A14 as well as the entirety of B
    MAC unit 1:
        Contains B11, B41, B31, and B21
    MAC unit 2:
        Contains B22, B12, B42, and B32
    MAC unit3:
        Contains B33, B23, B13, and B43
    MAC unit4:
        Contains B44, B34, B24, and B14
Second batch:
    Pass in A21, A22, A23, and A24
Third batch:
    Pass in A31, A32, A33, and A34
Fourth batch:
    Pass in A41, A42, A43, and A44
    
Structure:
            A11       A12       A13       A14
             |         |         |         |
             V         V         V         V
          [ B11 ]   [ B22 ]   [ B33 ]   [ B44 ]
          [ B41 ]   [ B12 ]   [ B23 ]   [ B34 ]
          [ B31 ]   [ B42 ]   [ B13 ]   [ B24 ]
          [ B21 ]   [ B32 ]   [ B43 ]   [ B14 ]

          [ A11 * B11 -> accumulator1 ]  [ A12 * B22 -> accumulator2 ] [ A13 * B33 -> accumulator3 ]  [ A14 * B44 -> accumulator4 ]
          [    B41                    ]  [    B12                    ] [    B23                    ]  [    B34                    ]
          [    B31                    ]  [    B42                    ] [    B13                    ]  [    B24                    ]
          [    B21                    ]  [    B32                    ] [    B43                    ]  [    B14                    ]

    ROTATE
    Values of A are rotated to the right with the value at the end coming to the front and values of B are rotated up with the value on top going to the bottom
    
            A14       A11       A12       A13
             |         |         |         |
             V         V         V         V
          [ B41 ]   [ B12 ]   [ B23 ]   [ B34 ]
          [ B31 ]   [ B42 ]   [ B13 ]   [ B24 ]
          [ B21 ]   [ B32 ]   [ B43 ]   [ B14 ]
          [ B11 ]   [ B22 ]   [ B33 ]   [ B44 ]

          [ A14 * B41 -> accumulator1 ]  [ A11 * B12 -> accumulator2 ] [ A12 * B23 -> accumulator3 ]  [ A13 * B34 -> accumulator4 ]
          
    ROTATE
            A13       A14       A11       A12
             |         |         |         |
             V         V         V         V
          [ B31 ]   [ B42 ]   [ B13 ]   [ B24 ]
          [ B21 ]   [ B32 ]   [ B43 ]   [ B14 ]
          [ B11 ]   [ B22 ]   [ B33 ]   [ B44 ]
          [ B41 ]   [ B12 ]   [ B23 ]   [ B34 ]

          [ A13 * B31 -> accumulator1 ]  [ A14 * B42 -> accumulator2 ] [ A11 * B13 -> accumulator3 ]  [ A12 * B24 -> accumulator4 ]

    LAST ROTATE
            A12       A13       A14       A11
             |         |         |         |
             V         V         V         V
          [ B21 ]   [ B32 ]   [ B43 ]   [ B14 ]
          [ B11 ]   [ B22 ]   [ B33 ]   [ B44 ]
          [ B41 ]   [ B12 ]   [ B23 ]   [ B34 ]
          [ B31 ]   [ B42 ]   [ B13 ]   [ B24 ]

          [ A12 * B21 -> accumulator1 ]  [ A13 * B32 -> accumulator2 ] [ A14 * B43 -> accumulator3 ]  [ A11 * B14 -> accumulator4 ]

The inputs for this module are as follows:
Array 1: [ A11  A12  A13  A14 ]
         [ A21  A22  A23  A24 ]
         [ A31  A32  A33  A34 ]
         [ A41  A42  A43  A44 ]

Array 2: [ B11  B12  B13  B14 ]
         [ B21  B22  B23  B24 ]
         [ B31  B32  B33  B34 ]
         [ B41  B42  B43  B44 ]

Output:  [ out11=A11*B11 + A12*B21 + A13*B31 + A14*B41  out12=A11*B12 + A12*B22 + A13*B32 + A14*B42  out13=A11*B13 + A12*B23 + A13*B33 + A14*B43  out14=A11*B14 + A12*B24 + A13*B34 + A14*B44 ]
         [ out21=A21*B11 + A22*B21 + A23*B31 + A24*B41  out22=A21*B12 + A22*B22 + A23*B32 + A24*B42  out23=A21*B13 + A22*B23 + A23*B33 + A24*B43  out24=A21*B14 + A22*B24 + A23*B34 + A24*B44 ]
         [ out31=A31*B11 + A32*B21 + A33*B31 + A34*B41  out32=A31*B12 + A32*B22 + A33*B32 + A34*B42  out33=A31*B13 + A32*B23 + A33*B33 + A34*B43  out34=A31*B14 + A32*B24 + A33*B34 + A34*B44 ]
         [ out41=A41*B11 + A42*B21 + A43*B31 + A44*B41  out42=A41*B12 + A42*B22 + A43*B32 + A44*B42  out43=A41*B13 + A42*B23 + A43*B33 + A44*B43  out44=A41*B14 + A42*B24 + A43*B34 + A44*B44 ]

Additional note, out11, out12, out13, and out14 will be completed first and may be used preemptively as these values will be held.
After an additional 120 cycles, the next batch will be complete: out21, out22, out23, and out24
out31, out32, out33, and out34 will be 120 cycles after the second batch and the last batch will be complete at the full 480 cycles.

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
