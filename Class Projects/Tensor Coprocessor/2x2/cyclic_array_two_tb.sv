`timescale 1ns/1ps

module mymulttb;

  reg clk, reset;

  always #5 clk = ~clk;

  initial begin
    clk = 0;
  end

  logic [31:0] a, b, c, d, i, j, k, l;
  logic [31:0] r1, r2, r3, r4;
  int n;
  logic start;
  logic [49:0] mult;
  logic [9:0] sum;
  logic done;
  logic sign;
  logic [31:0] out;

  cyclic_array_two DUT (
    .clk(clk),
    .rst(reset),
    .start(start),
    .done(done),
    .A(a),
    .B(b),
    .C(c),
    .D(d),
    .I(i),
    .J(j),
    .K(k),
    .L(l),
    .out1(r1),
    .out2(r2),
    .out3(r3),
    .out4(r4)
  );

  int cycles, delta;
  initial cycles = 0;
  always @(posedge clk)
    cycles = cycles + 1;

  initial begin
    a = 32'b00111111100000000000000000000000;
    b = 32'b01000000000000000000000000000000;
    c = 32'b01000000010000000000000000000000;
    d = 32'b01000000100000000000000000000000;
    i = 32'b00111111100000000000000000000000;
    j = 32'b01000000000000000000000000000000;
    k = 32'b01000000010000000000000000000000;
    l = 32'b01000000100000000000000000000000;
    start = 0;

    $dumpfile("trace.vcd");
    $dumpvars(0, mymulttb);
    
    for (n = 0; n < 10; n = n + 1) begin
      
      reset = 1;
      @(posedge clk);
      reset = 0;
      @(posedge clk);
      start = 1;
      @(posedge clk);
      start = 0;

      delta = cycles;
      wait(done);
      delta = cycles - delta;

      $display("r1 %b r2 %b r3 %b r4 %b cycles %d", r1, r2, r3, r4, delta);
      
      @(posedge clk);
      
      a = 32'b10111111000000000000000000000000;
      b = 32'b00111110100000000000000000000000;
      c = 32'b00111111010000000000000000000000;
      d = 32'b00111110000000000000000000000000;
      i = 32'b00111111101100000000000000000000;
      j = 32'b11000000001000000000000000000000;
      k = 32'b11000000100101000000000000000000;
      l = 32'b01000000011000000000000000000000;

    end

    $finish;
  end

endmodule