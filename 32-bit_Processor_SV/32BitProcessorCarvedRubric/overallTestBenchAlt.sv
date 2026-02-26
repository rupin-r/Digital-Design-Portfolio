`include "Instruction_Memory.sv"

`timescale 1ps/100fs

`define DELAY 400

//You should not need to edit anything in this file, you should just need to run it
module processor_tb;
  
  reg [4:0] word_address;
  wire [31:0] instruction;
  wire [5:0] Func, Opcode;
  wire [4:0] Rs, Rt;
  wire [15:0] Immediate;
  wire MemtoReg, MemWrite, PCSrc, ALUSrc, RegDst, RegWrite, Zero, Overflow;
  wire [3:0] ALUControl;
  wire [31:0] Result;
  
  inst_mem i(.addr(word_address), .data(instruction));
  
  top t(.Instr(instruction), 
        .top_Func(Func),
        .top_Opcode(Opcode), 
        .top_Rs_number(Rs), 
        .top_Rt_number(Rt), 
        .top_Immediate_16(Immediate), 
        .top_ALUResult(Result), 
        .top_MemtoReg(MemtoReg), 
        .top_MemWrite(MemWrite), 
        .top_PCSrc(PCSrc), 
        .top_ALUSrc(ALUSrc), 
        .top_RegDst(RegDst), 
        .top_RegWrite(RegWrite), 
        .top_Zero(Zero),
        .top_Overflow(Overflow),
        .top_ALUControl(ALUControl)
       );
  
  initial begin
    word_address = 0;
  end
  
  always begin
    #(`DELAY) word_address = word_address + 1;
  end
  
  
  always begin
    #1 $display("Ins 1 AND case 1");
    #389 if(Result != 'h00000000) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 1) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0000) $display("ALUControl is incorrect");
    //0x0000 0000	0	0	1	1	0	0	1	0	b0000
//done
    #10 $display("Ins 2 AND case 2");
    
    #390 if(Result != 'h01010101) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0000) $display("ALUControl is incorrect");
    //0x0101 0101	0	0	1	1	0	0	0	0	b0000
//done
    #10 $display("Ins 3 OR case 1");
    
    #390 if(Result != 'hAFADFCDF) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0001) $display("ALUControl is incorrect");
    //0xAFAD FCDF	0	0	1	1	0	0	0	0	b0001
//done
    #10 $display("Ins 4 OR case 2");
    
    #390 if(Result != 'h7FFFFFFF) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 1) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0001) $display("ALUControl is incorrect");
    //0x7FFF FFFF	0	0	1	1	0	0	0	1	b0001
//done
    #10 $display("Ins 5 ADD case 1");
    
    #390 if(Result != 'h00000003) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0010) $display("ALUControl is incorrect");
    //0x0000 0003	0	0	1	1	0	0	0	0	b0010
//done
    #10 $display("Ins 6 ADD case 2");
    
    #390 if(Result != 'h00000013) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0010) $display("ALUControl is incorrect");
    //0x0000 0013	0	0	1	1	0	0	0	0	b0010
//done
    #10 $display("Ins 7 SUB case 1");
    
    #390 if(Result != 'hA8A5FA98) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0110) $display("ALUControl is incorrect");
    //0xA8A5 FA98	0	0	1	1	0	0	0	0	b0110
//done
    #10 $display("Ins 8 SUB case 2");
    
    #390 if(Result != 'h0000000B) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0110) $display("ALUControl is incorrect");
    //0x0000 000B	0	0	1	1	0	0	0	0	b0110
//done
    #10 $display("Ins 9 SLT case 1");
    
    #390 if(Result != 'h00000001) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0111) $display("ALUControl is incorrect");
    //0x0000 0001	0	0	1	1	0	0	0	0	b0111
//done
    #10 $display("Ins 10 SLT case 2");
    
    #390 if(Result != 'h00000000) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 1) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0111) $display("ALUControl is incorrect");
    //0x0000 0000	0	0	1	1	0	0	1	0	b0111
//done
    #10 $display("Ins 11 BEQ case 1");
    
    #390 if(Result != 'hAB2F0BF3) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegWrite != 0) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0110) $display("ALUControl is incorrect");
    //0xAB2F 0BF3	0	0	0	0	0	0	0	0	b0110
//done
    #10 $display("Ins 12 BEQ case 2");
    
    #390 if(Result != 'h010100F1) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegWrite != 0) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0110) $display("ALUControl is incorrect");
    //0x0101 00F1	0	0	0	0	0	0	0	0	b0110
//done
    #10 $display("Ins 13 LW case 1");
    
    #390 if(Result != 'h98FEA745) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 1) $display("MemtoReg is incorrect");
    if(RegDst != 1) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 1) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0010) $display("ALUControl is incorrect");
    //0x98FE A745	0	1	0	1	1	0	0	0	b0010
//done
    #10 $display("Ins 14 LW case 2");
    
    #390 if(Result != 'h00840148) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 1) $display("MemtoReg is incorrect");
    if(RegDst != 1) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 1) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0010) $display("ALUControl is incorrect");
    //0x0084 0148	0	1	0	1	1	0	0	0	b0010
//done
    #10 $display("Ins 15 SW case 1");
    
    #390 if(Result != 'h53183483) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 1) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegWrite != 0) $display("RegWrite is incorrect");
    if(ALUSrc != 1) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0010) $display("ALUControl is incorrect");
    //0x5318 3483	1	0	0	0	1	0	0	0	b0010
//done
    #10 $display("Ins 16 SW case 2");
    
    #390 if(Result != 'h531840A6) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 1) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegWrite != 0) $display("RegWrite is incorrect");
    if(ALUSrc != 1) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0010) $display("ALUControl is incorrect");
    //0x5318 40A6	1	0	0	0	1	0	0	0	b0010
//done
    #10 $display("Ins 17 AND case 3");
    
    #390 if(Result != 'h00004027) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0000) $display("ALUControl is incorrect");
    //0x0000 4027	0	0	1	1	0	0	0	0	b0000
//done
    #10 $display("Ins 18 AND case 4");
    
    #390 if(Result != 'h00000000) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 1) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0000) $display("ALUControl is incorrect");
    //0x0000 0000	0	0	1	1	0	0	1	0	b0000
//done
    #10 $display("Ins 19 OR case 3");
    
    #390 if(Result != 'hFFFFFFFF) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0001) $display("ALUControl is incorrect");
    //0xFFFF FFFF	0	0	1	1	0	0	0	0	b0001
//done
    #10 $display("Ins 20 OR case 4");
    
    #390 if(Result != 'hF000EEEF) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0001) $display("ALUControl is incorrect");
    //0xF000 EEEF	0	0	1	1	0	0	0	0	b0001
//done
    #10 $display("Ins 21 ADD case 3");
    
    #390 if(Result != 'h92665E04) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 1) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0010) $display("ALUControl is incorrect");
    //0x9266 5E04	0	0	1	1	0	0	0	1	b0010
//done
    #10 $display("Ins 22 ADD case 4");
    
    #390 if(Result != 'h9CB9F2A0) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0010) $display("ALUControl is incorrect");
    //0x9CB9 F2A0	0	0	1	1	0	0	0	0	b0010
//done
    #10 $display("Ins 23 SUB case 3");
    
    #390 if(Result != 'hA427FBDD) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0110) $display("ALUControl is incorrect");
    //0xA427 FBDD	0	0	1	1	0	0	0	0	b0110
//done
    #10 $display("Ins 24 SUB case 4");
    
    #390 if(Result != 'h80000000) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 1) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0110) $display("ALUControl is incorrect");
    //0x8000 0000	0	0	1	1	0	0	0	1	b0110
//done
    #10 $display("Ins 25 SLT case 3");
    
    #390 if(Result != 'h00000000) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 1) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0111) $display("ALUControl is incorrect");
    //0x0000 0000	0	0	1	1	0	0	1	0	b0111
//done
    #10 $display("Ins 26 SLT case 4");
    
    #390 if(Result != 'h00000001) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegDst != 0) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0111) $display("ALUControl is incorrect");
    //0x0000 0001	0	0	1	1	0	0	0	0	b0111
//done
    #10 $display("Ins 27 BEQ case 3");
    
    #390 if(Result != 'h00000000) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegWrite != 0) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 1) $display("PCSrc is incorrect");
    if(Zero != 1) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0110) $display("ALUControl is incorrect");
    //0x0000 0000	0	0	0	0	0	1	1	0	b0110
//done
    #10 $display("Ins 28 BEQ case 4");
    
    #390 if(Result != 'h5350A555) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegWrite != 0) $display("RegWrite is incorrect");
    if(ALUSrc != 0) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 1) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0110) $display("ALUControl is incorrect");
    //0x5350 A555	0	0	0	0	0	0	0	1	b0110
//done
    #10 $display("Ins 29 LW case 3");
    
    #390 if(Result != 'h34200BEC) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 1) $display("MemtoReg is incorrect");
    if(RegDst != 1) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 1) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0010) $display("ALUControl is incorrect");
    //0x3420 0BEC	0	1	0	1	1	0	0	0	b0010
//done
    #10 $display("Ins 30 LW case 4");
    
    #390 if(Result != 'h00006F5D) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 0) $display("MemWrite is incorrect");
    if(MemtoReg != 1) $display("MemtoReg is incorrect");
    if(RegDst != 1) $display("RegDst is incorrect");
    if(RegWrite != 1) $display("RegWrite is incorrect");
    if(ALUSrc != 1) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0010) $display("ALUControl is incorrect");
    //0x0000 6F5D	0	1	0	1	1	0	0	0	b0010
//done
    #10 $display("Ins 31 SW case 3");
    
    #390 if(Result != 'h3F4E72A2) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 1) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegWrite != 0) $display("RegWrite is incorrect");
    if(ALUSrc != 1) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0010) $display("ALUControl is incorrect");
    //0x3F4E 72A2	1	0	0	0	1	0	0	0	b0010
//done
    #10 $display("Ins 32 SW case 4");
    
    #390 if(Result != 'hFFFFEDAF) $display("Result is incorrect, test 32 bit ALU");
    if(MemWrite != 1) $display("MemWrite is incorrect");
    if(MemtoReg != 0) $display("MemtoReg is incorrect");
    if(RegWrite != 0) $display("RegWrite is incorrect");
    if(ALUSrc != 1) $display("ALUSrc is incorrect");
    if(PCSrc != 0) $display("PCSrc is incorrect");
    if(Zero != 0) $display("Zero is incorrect, test 32 bit ALU");
    if(Overflow != 0) $display("Overflow is incorrect, test 32 bit ALU");
    if(ALUControl != 'b0010) $display("ALUControl is incorrect");
    //0xFFFF EDAF	1	0	0	0	1	0	0	0	b0010
//done
    #10 $display("Done testing. Finally.");
  end
  
  
  initial begin
    $dumpfile("a.vcd");
    $dumpvars();
  end
  
  initial #12800 $finish;
endmodule