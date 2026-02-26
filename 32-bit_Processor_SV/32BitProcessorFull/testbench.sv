`timescale 10ns/100ps

module prc_tb;
  reg clk;
  
  testing t(clk);
  
  initial begin
    clk = 0;
  end
  
  always begin
    #400 clk = !clk;
  end
  
  initial begin
    $dumpfile("a.vcd");
    $dumpvars();
  end
  
  initial #2800 $finish;
endmodule