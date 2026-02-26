`include "datapath.sv"
`include "control.sv"
`include "Instruction_Memory.sv"
  
`timescale 10ns/100ps

module testing(clk);
  input clk;
  reg [5:0] address;
  wire [31:0] instruction;
  wire MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, zero;
  wire [3:0] ALUOp;
  wire setToBranch;
  
  initial begin
    address = 0;
  end
  
  inst_mem i(.addr(address), .data(instruction));
  control c(.ins(instruction), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .Branch(Branch), .ALUSrc(ALUSrc), .RegDst(RegDst), .RegWrite(RegWrite), .ALUOp(ALUOp), .clk(clk));
  datapath d(.ins(instruction), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .Branch(Branch), .ALUSrc(ALUSrc), .RegDst(RegDst), .RegWrite(RegWrite), .ALUOp(ALUOp), .zero(zero), .clk(clk));
  
  and(setToBranch, zero, Branch);
  
  always @(posedge clk) begin
    if(setToBranch == 1'b1) begin
      address = address + 1 + instruction[15:0];
    end
    else begin
      address = address + 1;
    end
  end
  
endmodule