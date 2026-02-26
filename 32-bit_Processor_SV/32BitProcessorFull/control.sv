`timescale 10ns/100ps

module control(ins, MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, ALUOp, clk);
  input [31:0] ins;
  input clk;
  output MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite;
  output [3:0] ALUOp;
  reg [3:0] op;
  reg [5:0] flags;
  
  always @(posedge clk) begin
    case(ins[31:26])
      6'b000000: begin		//r-type
        if(ins[5:0] == 6'b100000) begin		//add
          op = 4'b0010;
        end
        if(ins[5:0] == 6'b100100) begin		//and
          op = 4'b0000;
        end
        if(ins[5:0] == 6'b100101) begin		//or
          op = 4'b0001;
        end
        if(ins[5:0] == 6'b100010) begin		//sub
          op = 4'b0110;
        end
        if(ins[5:0] == 6'b101010) begin		//slt
          op = 4'b0111;
        end
        flags = 6'b000001;
      end
      6'b001000: begin		//addi
        op = 4'b0010;
        flags = 6'b000111;
      end
      6'b101011: begin		//sw
        op = 4'b0010;
        flags = 6'b010100;
      end
      6'b100011: begin		//lw
        op = 4'b0010;
        flags = 6'b100111;
      end
      6'b000100: begin		//beq
        op = 4'b0110;
        flags = 6'b001000;
      end
    endcase
  end
  
  assign ALUOp = op;
  assign MemtoReg = flags[5:5];
  assign MemWrite = flags[4:4];
  assign Branch = flags[3:3];
  assign ALUSrc = flags[2:2];
  assign RegDst = flags[1:1];
  assign RegWrite = flags[0:0];
endmodule
    