`include "acc.sv"

/*
This module implements an IEEE 754 floating point multiplication of two values
It takes approximately 27 cycles to complete with 25 for multiplying mantissas
1 for accumulation (addition) and 1 for holding the output

This module ignores almost every special scenario such as NaN and infinity with the only exception being 0. TAKE CAUTION USING THIS MODULE AS IT IS NOT A COMPLETE FLOATING POINT MULTIPLIER BECAUSE IT IGNORES THESE SPECIAL VALUES. It also doesn't handle overflow because it doesn't handle infinity or NaN.

IEEE 754 Floating Point Multiplication:
Given a 32 bit value, break it down into 3 parts

1 bit sign bit
8 bit exponent
23 bit mantissa

The mantissa should be prepended with 1 for a 24 bit value as per IEEE 754 standards
The exponent bits are 127 biased and should be factored into the sum

To calculate the product, the 24 bit mantissas should be multiplied together
Then the exponent bits should be summed
And the sign bit should be xor'ed.

Because it is guaranteed that the 24 bit mantissas start with 1, the output is guaranteed to start with 1 as well. Then in IEEE 754 format, only the top 24 bits matter in the multiplication. Because of this, the bottom 24 bits of the multiplication can be ignored leading to less storage space required.

Multiplication is given as follows:
output = (output >> 1) + A if B[0]
output = (output >> 1) + A if B[1]
output = (output >> 1) + A if B[2]
                 .
                 .
                 .
output = (output >> 1) + A if B[21]
output = (output >> 1) + A if B[22]
output = (output >> 1) + A if B[23]

where output is 25 bits (24 bits + 1 overflow bit) and both A and B are 24 bits

The shifting of 1 is due to zero padding when multiplying values with more than one digit
This bit at the end will not generate a carry bit because of the padding which means it will not contribute to the top 24 bit product and can be shifted out

Since it is 24 bit multiplication, there's a possibility of an overflow bit
The overflow bit must be accounted for and goes into normalization

If there is overflow, add 1 to the exponent sum
output_exp = A_exp + B_exp - 127 (for bias) + overflow bit


The inputs for this module are as follows:
A:    A 32 bit IEEE 754 floating point value
B:    A 32 bit IEEE 754 floating point value
out:  A * B as a 32 bit IEEE 754 floating point value
out2: accumulator output as a 32 bit IEEE 754 floating point value
      It should be noted that out2 = out2 + A*B where initial value of out2 is 0
      It must be reset to go back to 0 or it will keep incrementing

clk:   The system clk positive edge trigger
rst:   A combination of reset_mult from cyclic array and system rst, positive edge trigger
start: Signal received from internal rotation to begin a multiplication
       Multiplication only begins when start goes low after going high
       Start may be held high indefinitely, but no multiplication will occur
done:  An output bit signaling that both multiplication and accumulation are done
       To just signal that multiplication is done, assign done = count[3] && count[4]

*/

module multiply(input [31:0] A,
                input [31:0] B,
                input clk, input rst,
                input start,
                output [31:0] out,
                output [31:0] out2,
                output done);
  
  //Stores the multiplication result of the mantissas
  reg [25:0] result;
  //Stores the number of bits passed through for multiplication of mantissas
  reg [4:0] count;
  
  //IEEE 754 floating point multiplication: exponents are summed
  wire [8:0] sum;
  //normalization of exponent sum in case mantissa multiplication overflows
  wire [8:0] re_sum;
  
  //lag the done signal to give time for the accumulator
  wire done_mult;
  wire start_add;
  
  //loop logic
  always_ff @(posedge clk, posedge rst) begin
    //reset all registers to 0
    if (rst) begin
      result <= 0;
      count <= 0;
    end
    //if start, also reset registers to 0
    else if (start) begin
      result <= 0;
      count <= 0;
    end
    //as long as multiplication is not done, do the multiplication
    else if (!done_mult) begin
      //multiplication explained above
      if (B[count] || (count == 23)) begin
        result <= (result >> 1) + {1'b1, A[22:0]};
      end
      else begin
        result <= (result >> 1);
      end
      //always increment bit count by 1
      count <= count + 1;
    end
    //this is just for adding lag time
    else if (!done) begin
      count <= count + 1;
    end
  end
  
  //calculate sum of exponents
  assign sum = A[30:23] + B[30:23];
  //normalization with overflow bit result[24] (25th bit of 24 bit multiplication)
  assign re_sum = sum - 127 + result[24];
  
  //If one of the inputs are 0, the output is immediately 0
  //Otherwise, grab the normalized multiplication output
  assign out[22:0] = (A[30:0] == 0 || B[30:0] == 0) ? 23'b0 : (result[24] ? result[23:1] : result[22:0]);
  //If one of the inputs are 0, the output is immediately 0
  //Otherwise, grab the normalized exponent output
  assign out[30:23] = (A[30:0] == 0 || B[30:0] == 0) ? 8'b0 : re_sum[7:0];
  //Even with normalization, this always calculates the sign bit
  assign out[31] = A[31] ^ B[31];
  
  //done flags
  assign done_mult = count[3] && count[4];
  assign start_add = count[3] && count[4] && count[0];
  assign done = count[1] && count[3] && count[4];
  
  //accumulator adds the multiplication output (in A) to its stored value
  accumulate acc (.A(out), .rst(rst), .out(out2), .clk(clk), .load(start_add));
  
endmodule