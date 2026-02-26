`timescale 1ns/1ps

/*
This module implements an IEEE 754 floating point addition of two values
It's entirely combinational with registers just to store the output

This module ignores almost every special scenario such as NaN and infinity with the only exception being 0. TAKE CAUTION USING THIS MODULE AS IT IS NOT A COMPLETE FLOATING POINT ACCUMULATOR BECAUSE IT IGNORES THESE SPECIAL VALUES. It also doesn't handle overflow because it doesn't handle infinity or NaN.

IEEE 754 Floating Point Multiplication:
Given a 32 bit value, break it down into 3 parts

1 bit sign bit
8 bit exponent
23 bit mantissa

The mantissa should be prepended with 1 for a 24 bit value as per IEEE 754 standards
The exponent bits are 127 biased and should be factored in

To calculate the sum, there are 7 main steps:
Given 32 bit floating point values A and B,
First, you need to figure out which exponent is bigger for A and B

Once you determine which has a higher exponent, shift the lower one's 24 bit mantissa value right by the difference in exponent values
Now you have two mantissa values, one normal and one shifted right

Then you need to figure out whether to do addition or subtraction based on the sign bits
Either do addition or subtraction of the smaller one to the bigger one

Since there was shifting and either addition or subtraction, the output might have leading zeroes and isn't guaranteed to start with 1 like floating point multiplication does
So count the number of leading zeroes

Shift the result by the number of leading zeroes so it does start with 1
This becomes the mantissa value

The exponent value is calculated by taking the bigger exponent and subtracting the number of leading zeroes.

The sign bit is taken from the one with a higher exponent. If the exponents are equal, the sign bit is taken from the result of the mantissa operation

The inputs for this module are as follows:
A:   The value to accumulate the output by
out: The accumulated value of incrementing A every clk
clk: Not system clk, controlled by done signals of the multiplier, positive edge trigger
rst: A combination of reset_mult from cyclic array and system rst, positive edge trigger

*/

module accumulate(input [31:0] A,
                  output [31:0] out,
                  input clk, rst, load);
  
  //stores the accumulated value
  reg [31:0] B;
  
  //calculated exponent difference of A and B
  wire signed [8:0] exp_diff;
  //absolute value for shifting
  wire signed [8:0] exp_diff_abs;
  //shifted mantissas
  wire [23:0] A_shift;
  wire [23:0] B_shift;
  
  //unshifted mantissas
  wire [23:0] A_hold;
  wire [23:0] B_hold;
  
  //addition or subtraction result
  wire signed [24:0] sum;
  //shifted addition or subtraction result
  wire [24:0] new_sum;
  
  //determines addition or subtraction
  wire sign;
  
  //count number of leading zeroes
  wire [4:0] leading_zeroes;
  
  //combinational logic output that will eventually be stored in the register
  wire [31:0] out_hold;

  //loop logic
  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      B <= 0;
    end
    //handle the zero values here instead of alongside combinational logic
    else if (load) begin
      if (B[30:23] == 0) begin
        B <= A;
      end
      else if (A[30:23] == 0) begin
        B <= B;
      end
      else begin
        B <= out_hold;
      end
    end
  end
    
  //calculate exponent difference
  assign exp_diff = A[30:23] - B[30:23];
  //absolute value using a mux and inverter
  //I actually have no clue why I'm not supposed to add 1 here for 2s complement logic
  assign exp_diff_abs = exp_diff < 0 ? exp_diff * (-1) : exp_diff;
  
  //create mantissa values
  assign A_hold = {1'b1, A[22:0]};
  assign B_hold = {1'b1, B[22:0]};
  
  //shift based on which exponent was greater (is exp difference positive or negative
  assign A_shift = exp_diff < 0 ? A_hold >> exp_diff_abs : A_hold;
  assign B_shift = exp_diff < 0 ? B_hold : B_hold >> exp_diff_abs;
  
  //determine add or subtract
  assign sign = A[31] ^ B[31];
  
  //If B is bigger, put B before A. Otherwise put A before B
  //If the sign bit is positive, exponents didn't match so subtract. Otherwise add
  assign sum = exp_diff < 0 ? sign ? B_shift[23:0] - A_shift[23:0] : B_shift[23:0] + A_shift[23:0] : sign ? A_shift[23:0] - B_shift[23:0] : A_shift[23:0] + B_shift[23:0];
    
  //find number of leading zeroes
  //I couldn't find a better way to find leading zeroes with arbitrary number of 1s
  //There is technically one that uses parity and subtraction, but it's quite complicated
  assign leading_zeroes = sum[24] ? 0 : sum[23] ? 1 : sum[22] ? 2 : sum[21] ? 3 : sum[20] ? 4 : sum[19] ? 5 : sum[18] ? 6 : sum[17] ? 7 : sum[16] ? 8 : sum[15] ? 9 : sum[14] ? 10 : sum[13] ? 11 : sum[12] ? 12 : sum[11] ? 13 : sum[10] ? 14 : sum[9] ? 15 : sum[8] ? 16 : sum[7] ? 17 : sum[6] ? 18 : sum[5] ? 19 : sum[4] ? 20 : sum[3] ? 21 : sum[2] ? 22 : sum[1] ? 23 : 24; 
  
  //shift sum by number of leading zeroes
  assign new_sum = sum << leading_zeroes;
  
  //get the sign bit from the bigger exponent value 
  //or from sum[24] (overflow bit means negative only if subtraction ocurred)
  //otherwise, just take it from A arbitrarily
  assign out_hold[31] = exp_diff < 0 ? B[31] : exp_diff > 0 ? A[31] : sign ? sum[24] : A[31];
  
  //subtract leading zeroes from greater exponent value
  //add 1 is because I zero indexed the search for leading zeroes
  assign out_hold[30:23] = exp_diff < 0 ? leading_zeroes == 0 ? B[30:23] + 1 : B[30:23] - leading_zeroes + 1 : leading_zeroes == 0 ? A[30:23] + 1 : A[30:23] - leading_zeroes + 1;
  
  //don't use shifted sum if leading zeroes is 0
  assign out_hold[22:0] = leading_zeroes == 0 ? sum[23:1] : new_sum[23:1];
  
  assign out = B;
  
endmodule