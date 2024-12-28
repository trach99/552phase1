module cache_word #(
    parameter WIDTH = 16
) (
    input clk,
    input rst,
    input [WIDTH-1:0] data_in,
    input wen,
    input enable,
    output [WIDTH-1:0] data_out
);

  cache_cell cells[WIDTH-1:0] (
      .clk(clk),
      .rst(rst),
      .data_in(data_in),
      .wen(wen),
      .enable(enable),
      .data_out(data_out)
  );

endmodule  // cache_word
