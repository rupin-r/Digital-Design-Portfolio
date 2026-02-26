`timescale 10ns/100ps

module ALU(A, B, control, out, overflow, zero);
  input [31:0] A, B;
  input [3:0] control;
  output [31:0] out;
  output overflow, zero;
  
  wire [31:0] cout;
  wire finalSet;
  wire o,s;
  
  oneBitALU z(.At(A[0:0]), .Bt(B[0:0]), .Cin(control[2:2]), .Less(finalSet), .Result(out[0:0]), .Overflow(o), .Cout(cout[0:0]), .Set(s), .control(control));
  
  oneBitALU one(.At(A[1:1]), .Bt(B[1:1]), .Cin(cout[0:0]), .Less(0), .Result(out[1:1]), .Overflow(o), .Cout(cout[1:1]), .Set(s), .control(control));
  
  oneBitALU two(.At(A[2:2]), .Bt(B[2:2]), .Cin(cout[1:1]), .Less(0), .Result(out[2:2]), .Overflow(o), .Cout(cout[2:2]), .Set(s), .control(control));
  
  oneBitALU three(.At(A[3:3]), .Bt(B[3:3]), .Cin(cout[2:2]), .Less(0), .Result(out[3:3]), .Overflow(o), .Cout(cout[3:3]), .Set(s), .control(control));
  
  oneBitALU four(.At(A[4:4]), .Bt(B[4:4]), .Cin(cout[3:3]), .Less(0), .Result(out[4:4]), .Overflow(o), .Cout(cout[4:4]), .Set(s), .control(control));
  
  oneBitALU five(.At(A[5:5]), .Bt(B[5:5]), .Cin(cout[4:4]), .Less(0), .Result(out[5:5]), .Overflow(o), .Cout(cout[5:5]), .Set(s), .control(control));
  
  oneBitALU six(.At(A[6:6]), .Bt(B[6:6]), .Cin(cout[5:5]), .Less(0), .Result(out[6:6]), .Overflow(o), .Cout(cout[6:6]), .Set(s), .control(control));
  
  oneBitALU seven(.At(A[7:7]), .Bt(B[7:7]), .Cin(cout[6:6]), .Less(0), .Result(out[7:7]), .Overflow(o), .Cout(cout[7:7]), .Set(s), .control(control));
  
  oneBitALU eight(.At(A[8:8]), .Bt(B[8:8]), .Cin(cout[7:7]), .Less(0), .Result(out[8:8]), .Overflow(o), .Cout(cout[8:8]), .Set(s), .control(control));
  
  oneBitALU nine(.At(A[9:9]), .Bt(B[9:9]), .Cin(cout[8:8]), .Less(0), .Result(out[9:9]), .Overflow(o), .Cout(cout[9:9]), .Set(s), .control(control));
  
  oneBitALU ten(.At(A[10:10]), .Bt(B[10:10]), .Cin(cout[9:9]), .Less(0), .Result(out[10:10]), .Overflow(o), .Cout(cout[10:10]), .Set(s), .control(control));
  
  oneBitALU eleven(.At(A[11:11]), .Bt(B[11:11]), .Cin(cout[10:10]), .Less(0), .Result(out[11:11]), .Overflow(o), .Cout(cout[11:11]), .Set(s), .control(control));
  
  oneBitALU twelve(.At(A[12:12]), .Bt(B[12:12]), .Cin(cout[11:11]), .Less(0), .Result(out[12:12]), .Overflow(o), .Cout(cout[12:12]), .Set(s), .control(control));
  
  oneBitALU thirteen(.At(A[13:13]), .Bt(B[13:13]), .Cin(cout[12:12]), .Less(0), .Result(out[13:13]), .Overflow(o), .Cout(cout[13:13]), .Set(s), .control(control));
  
  oneBitALU fourteen(.At(A[14:14]), .Bt(B[14:14]), .Cin(cout[13:13]), .Less(0), .Result(out[14:14]), .Overflow(o), .Cout(cout[14:14]), .Set(s), .control(control));
  
  oneBitALU fifteen(.At(A[15:15]), .Bt(B[15:15]), .Cin(cout[14:14]), .Less(0), .Result(out[15:15]), .Overflow(o), .Cout(cout[15:15]), .Set(s), .control(control));
  
  oneBitALU sixteen(.At(A[16:16]), .Bt(B[16:16]), .Cin(cout[15:15]), .Less(0), .Result(out[16:16]), .Overflow(o), .Cout(cout[16:16]), .Set(s), .control(control));
  
  oneBitALU seventeen(.At(A[17:17]), .Bt(B[17:17]), .Cin(cout[16:16]), .Less(0), .Result(out[17:17]), .Overflow(o), .Cout(cout[17:17]), .Set(s), .control(control));
  
  oneBitALU eighteen(.At(A[18:18]), .Bt(B[18:18]), .Cin(cout[17:17]), .Less(0), .Result(out[18:18]), .Overflow(o), .Cout(cout[18:18]), .Set(s), .control(control));
  
  oneBitALU nineteen(.At(A[19:19]), .Bt(B[19:19]), .Cin(cout[18:18]), .Less(0), .Result(out[19:19]), .Overflow(o), .Cout(cout[19:19]), .Set(s), .control(control));
  
  oneBitALU twenty(.At(A[20:20]), .Bt(B[20:20]), .Cin(cout[19:19]), .Less(0), .Result(out[20:20]), .Overflow(o), .Cout(cout[20:20]), .Set(s), .control(control));
  
  oneBitALU twentyone(.At(A[21:21]), .Bt(B[21:21]), .Cin(cout[20:20]), .Less(0), .Result(out[21:21]), .Overflow(o), .Cout(cout[21:21]), .Set(s), .control(control));
  
  oneBitALU twentytwo(.At(A[22:22]), .Bt(B[22:22]), .Cin(cout[21:21]), .Less(0), .Result(out[22:22]), .Overflow(o), .Cout(cout[22:22]), .Set(s), .control(control));
  
  oneBitALU twentythree(.At(A[23:23]), .Bt(B[23:23]), .Cin(cout[22:22]), .Less(0), .Result(out[23:23]), .Overflow(o), .Cout(cout[23:23]), .Set(s), .control(control));
  
  oneBitALU twentyfour(.At(A[24:24]), .Bt(B[24:24]), .Cin(cout[23:23]), .Less(0), .Result(out[24:24]), .Overflow(o), .Cout(cout[24:24]), .Set(s), .control(control));  
  
  oneBitALU twentyfive(.At(A[25:25]), .Bt(B[25:25]), .Cin(cout[24:24]), .Less(0), .Result(out[25:25]), .Overflow(o), .Cout(cout[25:25]), .Set(s), .control(control));
  
  oneBitALU twentysix(.At(A[26:26]), .Bt(B[26:26]), .Cin(cout[25:25]), .Less(0), .Result(out[26:26]), .Overflow(o), .Cout(cout[26:26]), .Set(s), .control(control));
  
  oneBitALU twentyseven(.At(A[27:27]), .Bt(B[27:27]), .Cin(cout[26:26]), .Less(0), .Result(out[27:27]), .Overflow(o), .Cout(cout[27:27]), .Set(s), .control(control));
  
  oneBitALU twentyeight(.At(A[28:28]), .Bt(B[28:28]), .Cin(cout[27:27]), .Less(0), .Result(out[28:28]), .Overflow(o), .Cout(cout[28:28]), .Set(s), .control(control));
  
  oneBitALU twentynine(.At(A[29:29]), .Bt(B[29:29]), .Cin(cout[28:28]), .Less(0), .Result(out[29:29]), .Overflow(o), .Cout(cout[29:29]), .Set(s), .control(control));
  
  oneBitALU thirty(.At(A[30:30]), .Bt(B[30:30]), .Cin(cout[29:29]), .Less(0), .Result(out[30:30]), .Overflow(o), .Cout(cout[30:30]), .Set(s), .control(control));
  
  oneBitALU thirtyone(.At(A[31:31]), .Bt(B[31:31]), .Cin(cout[30:30]), .Less(0), .Result(out[31:31]), .Overflow(overflow), .Cout(cout[31:31]), .Set(finalSet), .control(control));
  
  wire zero_temp;
  or(zero_temp, out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7], out[8], out[9], out[10], out[11], out[12], out[13], out[14], out[15], out[16], out[17], out[18], out[19], out[20], out[21], out[22], out[23], out[24], out[25], out[26], out[27], out[28], out[29], out[30], out[31]);
  not(zero, zero_temp);
  
endmodule


module oneBitALU(At, Bt, Cin, Less, Result, Overflow, Cout, Set, control);
  input At, Bt, Cin, Less;
  input [3:0] control;
  output Result, Overflow, Cout, Set;
  
  //select logic
  wire A;
  wire B;
  wire notAt;
  wire notBt;
  
  not(notAt, At);
  not(notBt, Bt);
  
  mux2to1 selectA(.out(A), .A(At), .B(notAt), .S(control[3:3]));
  mux2to1 selectB(.out(B), .A(Bt), .B(notBt), .S(control[2:2]));
  
  //And logic
  wire AandB;
  and(AandB, A, B);
  
  //Or logic
  wire AorB;
  or(AorB, A, B);
 
  //sum logic
  wire AxorB;
  wire sum;
  
  xor(AxorB, A, B);
  xor(sum, AxorB, Cin);
  
  //carryout logic
  wire AxorBandCin;

  and(AxorBandCin, AxorB, Cin);
  or(Cout, AandB, AxorBandCin);
  
  //overflow logic
  wire notCin;
  not(notCin, Cin);
  
  wire overPos;
  and(overPos, AandB, notCin);
  
  wire notAandnotB;
  not(notAandnotB, AorB);
  wire overNeg;
  and(overNeg, notAandnotB, Cin);
  
  or(Overflow, overNeg, overPos);
  
  //Set logic
  xor(Set, Overflow, sum);
  
  mux4to1 m(.out(Result), .A(AandB), .B(sum), .C(AorB), .D(Less), .s1(control[0:0]), .s2(control[1:1]));
  
endmodule
    