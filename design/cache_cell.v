module cache_cell (
    input  clk,
    input  rst,
    input  data_in,
    input  wen,
    input  enable,
    output data_out
);
  wire q;
  assign data_out = enable ? q : 1'bz;
  dff dffm (
      .q  (q),
      .d  (data_in),
      .wen(enable & wen),
      .clk(clk),
      .rst(rst)
  );
endmodule
