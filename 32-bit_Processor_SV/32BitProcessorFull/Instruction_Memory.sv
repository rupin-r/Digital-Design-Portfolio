//------------------------------------------------
// Adapted from:
// David_Harris@hmc.edu 23 October 2005
// Updated to SystemVerilog dmh 12 November 2010
// External memories used by MIPS single-cycle
// processor
//------------------------------------------------
`timescale 10ns/100ps

module inst_mem(addr, data);


  input  [5:0]  addr; //address for the memory
  output [31:0] data; //data being returned
  reg [31:0] RAM[31:0]; //internal variable to store the data being read from the file

  initial
    begin
      $readmemh("memfile.dat",RAM); // initialize memory
    end

  assign data = RAM[addr]; // word aligned
endmodule