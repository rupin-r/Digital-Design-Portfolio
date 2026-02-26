module testALU;
  reg [31:0] A, B;
  reg [3:0] control;
  
  wire [31:0] Result;
  wire Overflow, Zero;
  
  //edit only this line to match module name and variable input names
  fullALU dut(.a(A), .b(B), .ALUCtrl(control), .Result(Result), .Overflow(Overflow), .Zero(Zero));
  
  initial begin
    A = 0;
    B = 0;
    control = 0;
  end
  
  always begin
    #10 if(Result != 'h00000000 || Zero != 1) $display("Initial Failed");
    
    #30 control = 0;
       A = 'h2E5C326F;
       B = 'hE4CB8FC0;
    #10 if(Result != 'h24480240 || Zero != 0) $display("AND 1 Failed");
    
    #40 A = 'h6FB4C607;
       B = 'hAA28DA69;
    #10 if(Result != 'h2A20C201 || Zero != 0) $display("AND 2 Failed");
    
    #40 A = 'h35557EBF;
       B = 'hCAAA8140;
    #10 if(Result != 'h00000000 || Zero != 1) $display("AND 3 Failed");
    
    #40 A = 'hAD158CC3;
       B = 'h55786537;
    #10 if(Result != 'h05100403 || Zero != 0) $display("AND 4 Failed");
    
    
    #40 control = 1;
       A = 'h8BE0FD0F;
       B = 'h82FBB168;
    #10 if(Result != 'h8BFBFD6F || Zero != 0) $display("OR 1 Failed");
    
    #40 A = 'h00000000;
       B = 'h00000000;
    #10 if(Result != 'h00000000 || Zero != 1) $display("OR 2 Failed");
    
    #40 A = 'h6C825BFF;
       B = 'h5F5F1A6E;
    #10 if(Result != 'h7FDF5BFF|| Zero != 0) $display("OR 3 Failed");
    
    #40 A = 'hF30A204B;
       B = 'hCAA9EA94;
    #10 if(Result != 'hFBABEADF || Zero != 0) $display("OR 4 Failed");
    
    
    #40 control = 13;
       A = 'h4137D4AC;
       B = 'h697A9736;
    #10 if(Result != 'hBECD6BDB || Zero != 0) $display("NAND 1 Failed");
    
    #40 A = 'h044C865C;
       B = 'h05CA088D;
    #10 if(Result != 'hFbb7FFF3 || Zero != 0) $display("NAND 2 Failed");
    
    #40 A = 'hDD0A68AD;
       B = 'hDD0A68AD;
    #10 if(Result != 'h22F59752 || Zero != 0) $display("NAND 3 Failed");
    
    #40 A = 'hF46291EC;
       B = 'h6DF97BB2;
    #10 if(Result != 'h9B9FEE5F || Zero != 0) $display("NAND 4 Failed");
    
    
    #40 control = 12;
       A = 'h4E66FDA5;
       B = 'h999FB7E2;
    #10 if(Result != 'h20000018 || Zero != 0) $display("NOR 1 Failed");
    
    #40 A = 'h272E990A;
       B = 'hD8D166F5;
    #10 if(Result != 'h00000000 || Zero != 1) $display("NOR 2 Failed");
    
    #40 A = 'hCD17AF88;
       B = 'h46CF13ED;
    #10 if(Result != 'h30204012 || Zero != 0) $display("NOR 3 Failed");
    
    #40 A = 'h475F1995;
       B = 'h18C8DAED;
    #10 if(Result != 'hA0202402 || Zero != 0) $display("NOR 4 Failed");
    
    
    #40 control = 2;
       A = 'h158F663B;
       B = 'hB61D8902;
    #10 if(Result != 'hCBACEF3D || Zero != 0 || Overflow != 0) $display("ADD 1 Failed");
    
    #40 A = 'h3F8E657D;
       B = 'h0BCC78F6;
    #10 if(Result != 'h4B5ADE73 || Zero != 0 || Overflow != 0) $display("ADD 2 Failed");
    
    #40 A = 'h87E32E3E;
       B = 'hFEC03695;
    #10 if(Result != 'h86A364D3 || Zero != 0 || Overflow != 0) $display("ADD 3 Failed");
    
    #40 A = 'h58180394;
       B = 'h1D84E824;
    #10 if(Result != 'h759CEBB8 || Zero != 0 || Overflow != 0) $display("ADD 4 Failed");
    
    
    #40 control = 6;
       A = 'h80502194;
       B = 'h10F69885;
    #10 if(Result != 'h6F59890F || Zero != 0 || Overflow != 1) $display("SUB 1 Failed");
    
    #40 A = 'hC4626DC0;
       B = 'hF8479639;
    #10 if(Result != 'hCC1AD787 || Zero != 0 || Overflow != 0) $display("SUB 2 Failed");
    
    #40 A = 'h5445FAF8;
       B = 'h5445FAF8;
    #10 if(Result != 'h00000000 || Zero != 1 || Overflow != 0) $display("SUB 3 Failed");
    
    #40 A = 'h782A27D8;
       B = 'hA82A046B;
    #10 if(Result != 'hD000236D || Zero != 0 || Overflow != 1) $display("SUB 4 Failed");
    
    
    #40 control = 7;
       A = 'h1BB33911;
       B = 'hF2A9B9CA;
    #10 if(Result != 'h00000000 || Zero != 1 || Overflow != 0) $display("SLT 1 Failed");
    
    #40 A = 'hD79DEAC5;
       B = 'h790512EB;
    #10 if(Overflow != 1) $display("SLT 2 Failed");
       
    #40 A = 'h4BD43916;
       B = 'h26238DEE;
    #10 if(Result != 'h00000000 || Zero != 1 || Overflow != 0) $display("SLT 3 Failed");
    
    #40 A = 'h396E5D22;
       B = 'h396E5D23;
    #10 if(Result != 'h00000001 || Zero != 0 || Overflow != 0) $display("SLT 4 Failed");
    
    #40 A = 'h00000000;
       B = 'h00000000;
    #10 if(Result != 'h00000000 || Zero != 1 || Overflow != 0) $display("SLT 5 Failed");
    
    #40 A = 'h00000000;
       B = 'hFFFFFFFF;
    #10 if(Result != 'h00000000 || Zero != 1 || Overflow != 0) $display("SLT 6 Failed");
    
    #40 A = 'hFFFFFFFF;
       B = 'h00000000;
    #10 if(Result != 'h00000001 || Zero != 0) $display("SLT 7 Failed");
    
    #40 A = 'h00000001;
       B = 'h00000001;
    #10 if(Result != 'h00000000 || Zero != 1 || Overflow != 0) $display("SLT 8 Failed");
  end
    
  initial begin
    $display("A\t\tB\t\tControl\tResult\t\tZero\tOverflow");
    $monitor("%h\t%h\t%h\t%h\t%b\t%b", A, B, control, Result, Zero, Overflow);
  end
  
  initial #1600 $finish;
    
endmodule