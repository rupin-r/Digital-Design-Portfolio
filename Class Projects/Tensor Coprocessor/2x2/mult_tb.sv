module mymulttb;

  reg clk, reset;

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    #5;
    reset = 1;
    #12;
    reset = 0;
  end

  logic [31:0] a, b;
  logic [31:0] r;
  int n;
  logic start;
  logic [49:0] mult;
  logic [9:0] sum;
  logic done;
  logic sign;
  logic [31:0] out;

  multiply DUT (
    .clk(clk),
    .rst(reset),
    .start(start),
    .done(done),
    .A(a),
    .B(b),
    .out(r)
  );

  int cycles, delta;
  initial cycles = 0;
  always @(posedge clk)
    cycles = cycles + 1;

  initial begin
    a = 31'b0;
    b = 31'b1;
    start = 0;

    $dumpfile("trace.vcd");
    $dumpvars(0, mymulttb);

    @(negedge reset);
    
    for (n = 0; n < 1000; n = n + 1) begin
      mult = {1'b1,a[22:0]} * {1'b1,b[22:0]};
      sum = a[30:23] + b[30:23];
      if (mult[47]) begin
        sum = sum - 126;
        out[22:0] = mult[46:24];
      end
      else begin
        sum = sum - 127;
        out[22:0] = mult[45:23];
      end
      sign = a[31] ^ b[31];
      
      out[31] = sign;
      out[30:23] = sum[7:0];
      
      start = 1;
      @(posedge clk);
      start = 0;

      delta = cycles;
      wait(done == 1);
      delta = cycles - delta;

      $display("a %b b %b m %b OK %b", a, b, out, out == r);
      
      @(posedge clk);

      a = $random;
      b = $random;

    end

    $finish;
  end

endmodule