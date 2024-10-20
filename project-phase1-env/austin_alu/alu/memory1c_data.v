//////////////////////////////////////
//
// Memory -- single cycle version
//
// written for CS/ECE 552, Spring '07
// Pratap Ramamurthy, 19 Mar 2006
//
// Modified for CS/ECE 552, Spring '18
// Gokul Ravi, 08 Mar 2018
//
// Modified for ECE 552, Fall '24 in Verilog 2001
// Boone Severson
//
// This is a byte-addressable,
// 16-bit wide memory
// Note: The last bit of the address has to be 0.
//
// All reads happen combinationally with zero delay.
// All writes occur on rising clock edge.
// Concurrent read and write not allowed.
//
// On reset, memory loads from file "loadfile_all.img".
// (You may change the name of the file in
// the $readmemh statement below.)
// File format:
//     @0
//     <hex data 0>
//     <hex data 1>
//     ...etc
//
//
//////////////////////////////////////

module memory1c_data #(
    parameter DWIDTH = 16,
    AWIDTH = 16
) (
    output [DWIDTH-1:0] data_out,
    input [DWIDTH-1:0] data_in,
    input [AWIDTH-1:0] addr,  // byte address, all accesses must be 2-byte aligned; [0] is ignored.
    input enable,
    input wr,
    input clk,
    input rst
);

  localparam MemSize = 2 ** (AWIDTH - 1);
  reg [DWIDTH-1:0] mem[0:MemSize-1];

  assign data_out = (enable & (~wr)) ? {mem[addr[AWIDTH-1:1]]} : {DWIDTH{1'b0}};  //Read

  // Loading can happen only once, at reset. Subsequent resets will not
  // reload the memory.
  reg loaded;
  initial begin
    loaded = 0;
  end

  always @(posedge clk) begin
    if (rst) begin
      if (!loaded) begin  //load hex image.
        $display("%m loading memory.");
        $readmemh("loadfile_data.img", mem);
        loaded <= 1;
      end

    end else begin
      if (enable & wr) begin  // Store data_in at mem[addr].
        $display("%m Writing 0x%h to address 0x%h.", data_in, addr[(AWIDTH-1):1]);
        mem[addr[(AWIDTH-1):1]] <= data_in;
      end
    end
  end

endmodule  // memory1c
