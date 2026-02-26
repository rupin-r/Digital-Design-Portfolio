module testOneBitALU;
  
  reg A, B, Cin, Less;
  reg [3:0] control;
  
  wire Result, Set, Overflow, Cout;
  
  //edit only this line to match module name and variable input names
  onebitALU test(.a(A), .b(B), .carryin(Cin), .less(Less), .result(Result), .overflow(Overflow), .set(Set), .carryout(Cout), .con(control));
  
  initial begin
    A = 0;
    B = 0;
    Cin = 0;
    Less = 0;
    control = 0;
  end
  
  always begin
    #50 B = !B;
  end
  
  always begin
    #100 A = !A;
  end
  
  always begin
    #200 Less = !Less;
  end
  
  always begin
    #50  Cin = !Cin;
    #50  Cin = !Cin;
    #50  Cin = !Cin;
    #100 Cin = !Cin;
    #50  Cin = !Cin;
    #50  Cin = !Cin;
    #50  Cin = Cin;
  end
  
  always begin
    #400 control = 1;
    #400 control = 13;
    #400 control = 12;
    #400 control = 2;
    #400 control = 6;
    #400 control = 10;
    #400 control = 3;
  end
  
  always begin
    #20 if (Result !== 0 || Set != 0 || Cout != 0) $display("AND 1 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 1) $display("AND 2 Failed");
    #50 if (Result !== 0 || Set != 1 || Cout != 0) $display("AND 3 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 1) $display("AND 4 Failed");
    #50 if (Result !== 0 ||             Cout != 0) $display("AND 5 Failed");
    #50 if (Result !== 0 || Set != 1 || Cout != 0) $display("AND 6 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 1) $display("AND 7 Failed");
    #50 if (Result !== 1 ||             Cout != 1) $display("AND 8 Failed");
  
    #50 if (Result !== 0 || Set != 0 || Cout != 0) $display("OR 1 Failed");
    #50 if (Result !== 1 || Set != 0 || Cout != 1) $display("OR 2 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 0) $display("OR 3 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 1) $display("OR 4 Failed");
    #50 if (Result !== 0 ||             Cout != 0) $display("OR 5 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 0) $display("OR 6 Failed");
    #50 if (Result !== 1 || Set != 0 || Cout != 1) $display("OR 7 Failed");
    #50 if (Result !== 1 ||             Cout != 1) $display("OR 8 Failed");
  
    #50 if (Result !== 1 ||             Cout != 1) $display("NAND 1 Failed");
    #50 if (Result !== 1 || Set != 0 || Cout != 1) $display("NAND 2 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 0) $display("NAND 3 Failed");
    #50 if (Result !== 0 ||             Cout != 0) $display("NAND 4 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 1) $display("NAND 5 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 0) $display("NAND 6 Failed");
    #50 if (Result !== 1 || Set != 0 || Cout != 1) $display("NAND 7 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 0) $display("NAND 8 Failed");
    
    #50 if (Result !== 1 ||             Cout != 1) $display("NOR 1 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 1) $display("NOR 2 Failed");
    #50 if (Result !== 0 || Set != 1 || Cout != 0) $display("NOR 3 Failed");
    #50 if (Result !== 0 ||             Cout != 0) $display("NOR 4 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 1) $display("NOR 5 Failed");
    #50 if (Result !== 0 || Set != 1 || Cout != 0) $display("NOR 6 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 1) $display("NOR 7 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 0) $display("NOR 8 Failed");
    
    #50 if (Result !== 0 || Set != 0 || Cout != 0 || Overflow != 0) $display("ADD 1 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 1 || Overflow != 0) $display("ADD 2 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 0 || Overflow != 0) $display("ADD 3 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 1 || Overflow != 0) $display("ADD 4 Failed");
    #50 if (Result !== 1 ||             Cout != 0 || Overflow != 1) $display("ADD 5 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 0 || Overflow != 0) $display("ADD 6 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 1 || Overflow != 0) $display("ADD 7 Failed");
    #50 if (Result !== 0 ||             Cout != 1 || Overflow != 1) $display("ADD 8 Failed");
    
    #50 if (Result !== 1 || Set != 1 || Cout != 0 || Overflow != 0) $display("SUB 1 Failed");
    #50 if (Result !== 1 ||             Cout != 0 || Overflow != 1) $display("SUB 2 Failed");
    #50 if (Result !== 0 ||             Cout != 1 || Overflow != 1) $display("SUB 3 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 1 || Overflow != 0) $display("SUB 4 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 1 || Overflow != 0) $display("SUB 5 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 0 || Overflow != 0) $display("SUB 6 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 1 || Overflow != 0) $display("SUB 7 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 0 || Overflow != 0) $display("SUB 8 Failed");
    
    #50 if (Result !== 1 || Set != 1 || Cout != 0 || Overflow != 0) $display("SUB2 1 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 1 || Overflow != 0) $display("SUB2 2 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 0 || Overflow != 0) $display("SUB2 3 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 1 || Overflow != 0) $display("SUB2 4 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 1 || Overflow != 0) $display("SUB2 5 Failed");
    #50 if (Result !== 0 ||             Cout != 1 || Overflow != 1) $display("SUB2 6 Failed");
    #50 if (Result !== 1 ||             Cout != 0 || Overflow != 1) $display("SUB2 7 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 0 || Overflow != 0) $display("SUB2 8 Failed");
    
    #50 if (Result !== 0 || Set != 0 || Cout != 0 || Overflow != 0) $display("SLT 1 Failed");
    #50 if (Result !== 0 || Set != 0 || Cout != 1 || Overflow != 0) $display("SLT 2 Failed");
    #50 if (Result !== 0 || Set != 1 || Cout != 0 || Overflow != 0) $display("SLT 3 Failed");
    #50 if (Result !== 0 || Set != 1 || Cout != 1 || Overflow != 0) $display("SLT 4 Failed");
    #50 if (Result !== 1 ||             Cout != 0 || Overflow != 1) $display("SLT 5 Failed");
    #50 if (Result !== 1 || Set != 1 || Cout != 0 || Overflow != 0) $display("SLT 6 Failed");
    #50 if (Result !== 1 || Set != 0 || Cout != 1 || Overflow != 0) $display("SLT 7 Failed");
    #50 if (Result !== 1 ||             Cout != 1 || Overflow != 1) $display("SLT 8 Failed");
    
  end
  
  initial
    begin
      $monitor("%b \t%b \t%b \t%b \t%h \t%b \t%b \t%b \t%b", Less, Cin, A, B, control, Result, Set, Cout, Overflow);
    end
  
  initial #3150 $finish;
  
endmodule