//make sure you include the files you need for the ALU, muxes, and sign extension
`include "RegisterFile.sv"

/*******************************************
/	Name: YOUR NAME HERE
/
/	Module name: datapath
/
/	Inputs:  5-bit rs number, 5-bit rt number, and 16 bit immediate
/			 Control bits ALUSrc, and ALUControl
/
/	Output:  The 32 bit ALU_result and 1 bit outputs Overflow and Zero
/
/	Purpose: YOU WRITE THIS, I DON'T WANT TO
/
/******************************************/

`timescale 1ps/100fs

module datapath(
  input [4:0] rs_number, rt_number,
  input [15:0] imm_16,
  input ALUSrc,
  input [3:0] ALUControl,
  output Zero,
  output [31:0] ALUResult
);
 
  
  //IMPLEMENT YOUR LOGIC HERE

  //fill in read rs and read rt with the 32 bit values you will use later
  registerFile read_registers(.A1(rs_number), 
                              .A2(rt_number), 
                              .RD1(/*_____*/), 
                              .RD2(/*_____*/));
  
  //16 to 32 bit sign extension
  
  //32 bit mux
  
  //32 bit ALU
  

endmodule