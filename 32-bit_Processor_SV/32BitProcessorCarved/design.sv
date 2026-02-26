`include "datapath.sv"
`include "control.sv"
//include the file to your instruction split here

  
/*******************************************
/	Name: YOUR NAME HERE
/
/	Module name: control
/
/	Inputs:  5-bit function code and 5-bit opcode.
/			 Also 1 bit input zero coming from the datapath
/
/	Output:  Control unit bits MemtoReg, MemWrite, ALUSrc, RegDst,
/			 Branch, and RegWrite
/
/	Purpose: YOU WRITE THIS, I DON'T WANT TO
/
/******************************************/

`timescale 1ps/100fs

module top(
  input [31:0] Instr,
  output [5:0] top_Func, top_Opcode,
  output [4:0] top_Rs_number, top_Rt_number,
  output [15:0] top_Immediate_16,
  output top_MemtoReg, top_MemWrite, top_PCSrc, top_ALUSrc, 
  output top_RegDst, top_RegWrite, top_Zero, top_Overflow,
  output [3:0] top_ALUControl,
  output [31:0] top_ALUResult
);
  
  
  //call to inst_split from lab7
  //fill in the blanks with the variable names from your lab 7 and include
  //the file at the top
  inst_split split(./*_____*/(Instr), 
                   ./*_____*/(top_Rs_number), 
                   ./*_____*/(top_Rt_number), 
                   ./*_____*/(top_Func), 
                   ./*_____*/(top_Opcode)
                   ./*_____*/(top_Immediate_16)
           );
                  
  //1 bit input zero from datapath
  //6 bit inputs Func and Opcode from inst_split
  //1 bit outputs MemtoReg, MemWrite, PCSrc, ALUSrc, RegDst, RegWrite
  //PCSrc will be a combination of your decode ANDed with zero
  control decoder(.Func(top_Func), 
                  .Opcode(top_Opcode), 
                  .MemtoReg(top_MemtoReg), 
                  .MemWrite(top_MemWrite), 
                  .PCSrc(top_PCSrc), 
                  .ALUSrc(top_ALUSrc), 
                  .RegDst(top_RegDst), 
                  .RegWrite(top_RegWrite), 
                  .ALUControl(top_ALUControl), 
                  .Zero(top_Zero)
           );
  
  //1 bit inputs ALUSrc from control
  //4 bit input ALUControl from control
  //5 bit inputs Rs_number and Rt_number from inst_split
  //16 bit input Immediate from inst_split
  //1 bit outputs zero
  //32 bit output ALU_result
  datapath path(.rs_number(top_Rs_number), 
                .rt_number(top_Rt_number), 
                .imm_16(top_Immediate_16), 
                .ALUSrc(top_ALUSrc), 
                .ALUControl(top_ALUControl), 
                .Zero(top_Zero),  
                .ALUResult(top_ALUResult)
            );
  
endmodule