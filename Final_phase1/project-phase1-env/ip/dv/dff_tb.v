// World's smallest tesbench
module dff_tb ();
  wire q;
  reg d, wen, rst, clk;

  integer clk_cnt = 0;
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  always @(posedge clk) begin
    clk_cnt <= rst ? 0 : clk_cnt + 1;
    {rst, wen, d} <= {rst, wen, d} + 1;
  end

  initial begin
    $dumpvars;
    {rst, wen, d} = 3'b100;
    @(posedge clk);
    repeat (32) @(posedge clk);
    $finish;
  end

  dff dflipflop (
      .q  (q),
      .d  (d),
      .wen(wen),
      .clk(clk),
      .rst(rst)
  );
endmodule  // dff_tb
