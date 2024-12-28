// ECE/CS 552 Metadata (aka Tag) Array Design File
// Tag Array with 64 sets
// Each set stores 8 bits for tag, valid, and LRU bit.
// set_enable is one-hot
// wen is 1 on writes and 0 on reads


//lru is 1 on LRU update cases (whenever accessed)

module metadata_way_array (
    input clk,
    input rst,
    input [7:0] data_in,
    input wen,
    input [63:0] set_enable,
    input lru_en,       //adding lru enable to update LRU bit
    output [7:0] data_out
);

// 8 bits divided into 7 bits of {Valid[6],Tag[5:0]} and LRU[7]

    //7 bits of Tag[5:0] and valid[6]
  cache_word #(
      .WIDTH(7)
  ) sets[63:0] (
      .clk(clk),
      .rst(rst),
      .data_in(data_in[6:0]),
      .wen(wen),
      .enable(set_enable),
      .data_out(data_out[6:0])
  );
    //Handling LRU[7] bit separately
  cache_word #(
      .WIDTH(1)
  ) sets_LRU[63:0] (
      .clk(clk),
      .rst(rst),
      .data_in(data_in[7]),
      .wen(wen | lru_en), 
      .enable(set_enable),
      .data_out(data_out[7])
  );
endmodule
