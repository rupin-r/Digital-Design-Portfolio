`include "ALU.sv"
`include "RegisterFile.sv"
`include "SignExtension.sv"
`include "muxes.sv"
`include "DataMemory.sv"

`timescale 10ns/100ps

module datapath(ins, MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, ALUOp, zero, clk);
  
  input [31:0] ins;
  input MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, clk;
  input [3:0] ALUOp;
  wire [31:0] rs_value, rt_value, imm_extend;
  wire [4:0] write_register;
  wire [31:0] write_value;
  wire [31:0] ALU_input;
  wire [31:0] ALU_result;
  wire [31:0] read_mem;
  wire overflow;
  output zero;

  //register file
  registerFile r(.rs(ins[25:21]), .rt(ins[20:16]), .rd(write_register), .read_rs(rs_value), .read_rt(rt_value), .write_rd(write_value), .writeEnable(RegWrite), .clk(clk));
  
  //sign extension
  sign_extender im(.in(ins[15:0]), .out(imm_extend));
  
  //32 bit mux for ALU
  mux2to1_32bit m1(.A(rt_value), .B(imm_extend), .S(ALUSrc), .out(ALU_input));
  
  //32 bit ALU
  ALU a(.A(rs_value), .B(ALU_input), .control(ALUOp), .out(ALU_result), .overflow(overflow), .zero(zero));
  
  //Data memory
  dataMem d(.address(ALU_result), .read_data(read_mem), .write_data(rt_value), .writeEnable(MemWrite), .clk(clk));
  
  //32 bit mux for writeback
  mux2to1_32bit m2(.out(write_value), .A(ALU_result), .B(read_mem), .S(MemtoReg));
  
  //5 bit mux for register destination
  mux2to1_5bit m3(.out(write_register), .A(ins[15:11]), .B(ins[20:16]), .S(RegDst));
  
endmodule