// ECE/CS 552 Data Array Design File
// Data Array with 64 sets
// Each set will have 8 words
// set_enable and word_enable are one-hot
// wen is 1 on writes and 0 on reads

module data_way_array (
    input clk,
    input rst,
    input [15:0] data_in,
    input wen,
    input [63:0] set_enable,
    input [7:0] word_enable,
    output [15:0] data_out
);
  data_set sets[63:0] (
      .clk(clk),
      .rst(rst),
      .data_in(data_in),
      .wen(wen),
      .enable(set_enable),
      .word_enable(word_enable),
      .data_out(data_out)
  );
endmodule
