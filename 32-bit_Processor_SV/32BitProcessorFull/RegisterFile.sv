/*******************************************
/	Module name: registerFile
/
/	Inputs:  5-bit location of rs, rt, and rd. 32-bit value to write into rd.
/			 the clock signal and a writeEnable signal that allows a value
/			 to be written into rd.
/
/	Trigger: Specifically a negative edge clock to write into the register
/			 file. Reading happens constantly and will not affect the output.
/
/	Output:  Two 32 bit output in read_rs and read_rt
/
/	Purpose: The regFile variable holds all register values with each register
/			 initialized to zero. Anytime rs or rt changes, the value read
/			 from the register file changes to that location. This happens
/			 instantaneously. However, this will not affect output because
/			 writing only happens on the negative clock edge.
/			 Writing to the register file will only happen if both writeEnable
/			 is high and the clock edge goes low.
/******************************************/

`timescale 10ns/100ps

module registerFile(rs, rt, rd, read_rs, read_rt, write_rd, clk, writeEnable);
  input [31:0] write_rd;				//define input data
  input [4:0] rs, rt, rd;				//define input locations
  output [31:0] read_rs, read_rt;		//define output data
  input clk, writeEnable;				//define triggers
  
  reg [31:0] regFile [31:0];			//this is the overall register file
  
  initial begin
    $readmemh("regfile.dat",regFile);	//initialize register file to all 0s
  end
  
  assign read_rs = regFile[rs];			//constantly update rs value and rt
  assign read_rt = regFile[rt];			//value based on the location of rs and rt
  
  always @(negedge clk) begin			//on the negative clock edge
    if(writeEnable) begin				//only if writeEnable is high
      regFile[rd] = write_rd;			//change the value in the register file at rd to the input data
    end
  end									//end the module
endmodule