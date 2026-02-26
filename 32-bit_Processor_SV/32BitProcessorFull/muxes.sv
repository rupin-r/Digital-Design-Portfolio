`timescale 10ns/100ps

module mux4to1(out, A, B, C, D, s1, s2);
  input A, B, C, D, s1, s2;
  output out;
  wire mux1, mux2;
  mux2to1 m1(.out(mux1), .A(A), .B(C), .S(s1));
  mux2to1 m2(.out(mux2), .A(B), .B(D), .S(s1));
  mux2to1 mf(.out(out), .A(mux1), .B(mux2), .S(s2));
  
endmodule  
  
module mux2to1(out, A, B, S);
  input A, B, S;
  output out;
  
  wire notS;
  not(notS, S);
  
  wire AandnotS;
  wire BandS;
  and(AandnotS, A, notS);
  and(BandS, B, S);
  
  or(out, BandS, AandnotS);
  
endmodule

module mux2to1_2bit(out, A, B, S);
  input [1:0] A, B;
  input S;
  output [1:0] out;
  
  mux2to1 zero(.out(out[0:0]), .A(A[0:0]), .B(B[0:0]), .S(S));
  mux2to1 one(.out(out[1:1]), .A(A[1:1]), .B(B[1:1]), .S(S));
endmodule

module mux2to1_4bit(out, A, B, S);
  input [3:0] A, B;
  input S;
  output [3:0] out;
  
  mux2to1_2bit zero(.out(out[1:0]), .A(A[1:0]), .B(B[1:0]), .S(S));
  mux2to1_2bit one(.out(out[3:2]), .A(A[3:2]), .B(B[3:2]), .S(S));
endmodule

module mux2to1_5bit(out, A, B, S);
  input [4:0] A, B;
  input S;
  output [4:0] out;
  
  mux2to1_2bit zero(.out(out[1:0]), .A(A[1:0]), .B(B[1:0]), .S(S));
  mux2to1_2bit one(.out(out[3:2]), .A(A[3:2]), .B(B[3:2]), .S(S));
  mux2to1 two(.out(out[4:4]), .A(A[4:4]), .B(B[4:4]), .S(S));
endmodule

module mux2to1_8bit(out, A, B, S);
  input [7:0] A, B;
  input S;
  output [7:0] out;
  
  mux2to1_4bit zero(.out(out[3:0]), .A(A[3:0]), .B(B[3:0]), .S(S));
  mux2to1_4bit one(.out(out[7:4]), .A(A[7:4]), .B(B[7:4]), .S(S));
endmodule

module mux2to1_16bit(out, A, B, S);
  input [15:0] A, B;
  input S;
  output [15:0] out;
  
  mux2to1_8bit zero(.out(out[7:0]), .A(A[7:0]), .B(B[7:0]), .S(S));
  mux2to1_8bit one(.out(out[15:8]), .A(A[15:8]), .B(B[15:8]), .S(S));
endmodule

module mux2to1_32bit(out, A, B, S);
  input [31:0] A, B;
  input S;
  output [31:0] out;
  
  mux2to1_16bit zero(.out(out[15:0]), .A(A[15:0]), .B(B[15:0]), .S(S));
  mux2to1_16bit one(.out(out[31:16]), .A(A[31:16]), .B(B[31:16]), .S(S));
endmodule
