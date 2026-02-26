//include files you need to use here

/*******************************************
/	Name: YOUR NAME HERE
/
/	Module name: control
/
/	Inputs:  6-bit function code and 6-bit opcode.
/			 Also 1 bit input zero coming from the datapath
/
/	Output:  Control unit bits MemtoReg, MemWrite, ALUSrc, RegDst,
/			 PCSrc, and RegWrite
/
/	Purpose: YOU WRITE THIS, I DON'T WANT TO
/
/******************************************/

`timescale 1ps/100fs

module control(
  input [5:0] Func, Opcode,
  input Zero,
  output MemtoReg, MemWrite, PCSrc, ALUSrc, RegDst, RegWrite,
  output [3:0] ALUControl
);
  
  
  //IMPLEMENT YOUR LOGIC HERE:
  
  //Main Decoder
  
  
  //ALU Decoder
  
endmodule
    