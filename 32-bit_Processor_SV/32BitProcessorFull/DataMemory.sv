/*******************************************
/
/   <3 Header creation and design flow credit to Rupin <3
/
/	Module name: dataMem
/
/	Inputs:  32b write data, 32b memory address, 1b enable and clk signal.
/
/	Trigger: a specifically negative edge clock to only write when the
/			 the clock signal goes low.
/
/	Output:  32b output in read_data
/
/	Purpose: Writes and reads 32b data values to/from a memory file at a 
/			 given 32b address. 
/			 Writes when write_enable = 1 at each falling clk edge. 
/			 Module always reads data from address.
/
/		**Assume memoryFile.dat file with 2^8 lines
/
/******************************************/

`timescale 10ns/100ps

module dataMem(address, read_data, write_data, clk, writeEnable);
  input [31:0] address, write_data;				//initialize input address and data
  output [31:0] read_data;						//initialize output data
  input clk, writeEnable;						//initialize triggers
  
  reg [31:0] dataMemory [255:0];				//the actual data memory variable
  
  initial begin
    $readmemh("datafile.dat",dataMemory); 		//initialize memory file to all zeroes
  end
  
  assign read_data = dataMemory[address[7:0]];	//always read from memory based on the given address
  
  always @(negedge clk) begin					//only on the negative clock
    if(writeEnable) begin						//and if writeEnable is high
      dataMemory[address[7:0]] = write_data;	//write the input data into the data memory file
    end
  end											//end the module
endmodule
