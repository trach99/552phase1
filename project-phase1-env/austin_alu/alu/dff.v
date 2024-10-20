// dff with synchronous rst.
module dff (
    output reg q,  // DFF output
    input d,  // DFF input
    input wen,  // Write Enable
    input clk,
    input rst  // synchronous reset
);

  always @(posedge clk) begin
    q <= rst ? 0 : (wen ? d : q);
  end

endmodule  // dff
