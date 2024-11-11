// World's smallest tesbench
module dff_tb ();
  wire [3:0] q;
  reg  [3:0] d;
  reg wen, rst, clk;

  integer clk_cnt = 0;
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  always @(posedge clk) begin
    clk_cnt <= rst ? 0 : clk_cnt + 1;
  end

  initial begin
    $dumpvars;
    {rst, wen, d} <= 6'b10_0000;
    @(posedge clk);
    repeat (2 ** 6) begin
      {rst, wen, d} <= $urandom;
      @(posedge clk);
    end
    $finish;
  end

  pldff #(
      .WIDTH(4)
  ) dff (
      .q  (q),
      .d  (d),
      .wen(wen),
      .clk(clk),
      .rst(rst)
  );
endmodule  // dff_tb
