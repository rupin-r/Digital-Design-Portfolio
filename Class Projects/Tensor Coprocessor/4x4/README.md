# File Descriptions

These details can also be found in the files themselves

--------------------
**cyclic_array_four.sv:**
--------------------

This module implements a 4x4 floating point matrix multiplier given full input and output port lists
It takes approximately 480 cycles to complete one 2x2 multiplication with held outputs

Approximately 27 cycles go into a single multiplication
25 cycles are for multiplication, one cycle for addition, and one for holding output
Then there are additional cycles used for resetting multipliers and sums

The matrix multiplication follows a cyclic array pattern to compute NxN matrix 
multiplication using N MAC units

The pattern is as follows

Given arrays A:  

    [ A11  A12  A13  A14 ]
    [ A21  A22  A23  A24 ]
    [ A31  A32  A33  A34 ]
    [ A41  A42  A43  A44 ]
                 
And B:  

    [ B11  B12  B13  B14 ]
    [ B21  B22  B23  B24 ]
    [ B31  B32  B33  B34 ]
    [ B41  B42  B43  B44 ]

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

Array 1:

    [ A11  A12  A13  A14 ]
    [ A21  A22  A23  A24 ]
    [ A31  A32  A33  A34 ]
    [ A41  A42  A43  A44 ]


Array 2: 

    [ B11  B12  B13  B14 ]
    [ B21  B22  B23  B24 ]
    [ B31  B32  B33  B34 ]
    [ B41  B42  B43  B44 ]


Output:  

    [ out11=A11B11 + A12B21 + A13B31 + A14B41  out12=A11B12 + A12B22 + A13B32 + A14B42  out13=A11B13 + A12B23 + A13B33 + A14B43  out14=A11B14 + A12B24 + A13B34 + A14B44 ]

    [ out21=A21B11 + A22B21 + A23B31 + A24B41  out22=A21B12 + A22B22 + A23B32 + A24B42  out23=A21B13 + A22B23 + A23B33 + A24B43  out24=A21B14 + A22B24 + A23B34 + A24B44 ]
         
    [ out31=A31B11 + A32B21 + A33B31 + A34B41  out32=A31B12 + A32B22 + A33B32 + A34B42  out33=A31B13 + A32B23 + A33B33 + A34B43  out34=A31B14 + A32B24 + A33B34 + A34B44 ]
         
    [ out41=A41B11 + A42B21 + A43B31 + A44B41  out42=A41B12 + A42B22 + A43B32 + A44B42  out43=A41B13 + A42B23 + A43B33 + A44B43  out44=A41B14 + A42B24 + A43B34 + A44B44 ]


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
       
--------------------
**external_rot_four.sv:**
--------------------

This module handles the external rotation of matrix multiplication with A matrix values

This module must be in sync with internal rotation since the A matrix rotates at the same time the B matrix rotates

The inputs for this module are as follows:

A:     A single 32 bit floating point value from matrix A

B:     A single 32 bit floating point value from matrix A

C:     A single 32 bit floating point value from matrix A

D:     A single 32 bit floating point value from matrix A

The entirety of matrix B is included here

A row output is given with output values

out1:  A single 32 bit floating point value denoting a matrix multiplication output

out2:  A single 32 bit floating point value denoting a matrix multiplication output

out3:  A single 32 bit floating point value denoting a matrix multiplication output

out4:  A single 32 bit floating point value denoting a matrix multiplication output

clk:   The system clk positive edge trigger

rst:   A combination of reset_mult from cyclic array and system rst, positive edge trigger

start: Comes from the overall design for reset synchronization

done:  Signifies when row of matrix multiplication is done for batch timing

--------------------
**internal_rot_four.sv:**
--------------------

--------------------
**mult.sv:**
--------------------

--------------------
**acc.sv:**
--------------------
