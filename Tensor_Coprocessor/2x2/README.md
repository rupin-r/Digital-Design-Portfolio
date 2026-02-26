# File Descriptions

These details can also be found in the files themselves

--------------------
**cyclic_array_four.sv:**
--------------------

This module implements a 2x2 floating point matrix multiplier given full input and output port lists
It takes approximately 120 cycles to complete one 2x2 multiplication with held outputs

Approximately 27 cycles go into a single multiplication
25 cycles are for multiplication, one cycle for addition, and one for holding output
Then there are additional cycles used for resetting multipliers and sums

The matrix multiplication follows a cyclic array pattern to compute NxN matrix 
multiplication using N MAC units

The pattern is as follows

Given arrays A:  

    [ A11  A12 ]
    [ A21  A22 ]
                 
And B:  

    [ B11  B12 ]
    [ B21  B22 ]

Then an output row can be computed with 4 MAC units and 4 rotations

First batch:

  Pass in A11 and A12 as well as the entirety of B
    
  MAC unit 1:
  Contains B11 and B21
    
  MAC unit 2:
  Contains B22 and B12
  

Second batch:
    Pass in A21 and A22

    
Structure:

            A11       A12 
             |         | 
             V         V  
          [ B11 ]   [ B22 ]  
          [ B21 ]   [ B12 ] 

          [ A11 * B11 -> accumulator1 ]  [ A12 * B22 -> accumulator2 ]
          [    B21                    ]  [    B12                    ]

    ROTATE
    
    Values of A are rotated to the right with the value at the end coming to the front and values of B are rotated up with the value on top going to the bottom
    
            A12       A11 
             |         |  
             V         V  
          [ B21 ]   [ B12 ]  
          [ B11 ]   [ B22 ] 

          [ A12 * B21 -> accumulator1 ]  [ A11 * B12 -> accumulator2 ]


The inputs for this module are as follows:

Array 1:

    [ A  B ]
    [ C  D ]


Array 2: 

    [ I  J ]
    [ K  L ]


Output:  

    [ out1 = AI + BK  out2 = AJ + BL ]

    [ out3 = CI + DK  out3 = CJ + DL ]


Additional note, out1, out2, out13, and out14 will be completed first and may be used preemptively as these values will be held.

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
       
--------------------
**external_rot_four.sv:**
--------------------

This module handles the external rotation of matrix multiplication with A matrix values

This module must be in sync with internal rotation since the A matrix rotates at the same time the B matrix rotates

The inputs for this module are as follows:

    A:     A single 32 bit floating point value from matrix A
    B:     A single 32 bit floating point value from matrix A

The entirety of matrix B is included here

A row output is given with output values:

    out1:  A single 32 bit floating point value denoting a matrix multiplication output
    out2:  A single 32 bit floating point value denoting a matrix multiplication output

    clk:   The system clk positive edge trigger
    rst:   A combination of reset_mult from cyclic array and system rst, positive edge trigger
    start: Comes from the overall design for reset synchronization
    done:  Signifies when row of matrix multiplication is done for batch timing

--------------------
**internal_rot_four.sv:**
--------------------

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

--------------------
**mult.sv:**
--------------------

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

--------------------
**acc.sv:**
--------------------

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

