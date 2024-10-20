// Testbench for memory1c.v
module memory1c_tb ();

  reg [15:0] shadow[0:32767];
  reg clk;
  integer clk_cnt = 0;
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  always @(posedge clk) begin
    clk_cnt <= rst ? 0 : clk_cnt + 1;
  end

  wire [15:0] data_out;
  reg  [15:0] data_in;
  reg  [15:0] addr;
  reg         enable;
  reg         wr;
  reg         rst;

  initial
    $monitor(
        "clk=%d addr=0x%h data_in=0x%h data_out=0x%h wr=%h enable=%h rst=%h",
        clk_cnt,
        addr,
        data_in,
        data_out,
        wr,
        enable,
        rst
    );

  wire [15:0] mem0 = mem.mem[0];
  wire [15:0] mem1 = mem.mem[1];
  wire [15:0] mem2 = mem.mem[2];
  integer i;
  initial begin
    $dumpvars;
    rst = 1'b1;
    data_in = 16'h0;
    addr = 16'h0;
    enable = 1'b0;
    wr = 1'b0;

    repeat (2) @(posedge clk);
    rst = 1'b0;
    repeat (2) @(posedge clk);

    $display("Starting...");
    // write value 'i' to address 'i'
    for (i = 0; i < 8; i++) begin
      @(negedge clk);  // update inputs on negedge
      enable = 1'b1;
      wr = 1'b1;
      addr = {i[14:0], 1'b0};
      data_in = i[15:0];
      @(posedge clk);  // synchronize inputs for DUT
    end

    // Read all addresses and compare. Note data_out will lag by 1 clock.
    for (i = 0; i < 8; i++) begin
      @(negedge clk);
      enable = 1'b1;
      wr = 1'b0;
      data_in = 16'hxxxx;
      addr = {i[14:0], 1'b0};
      @(posedge clk);
    end

    $writememh("mem_out.img",mem.mem);
    $finish;
  end

  memory1c #(
      .DWIDTH(16),
      .AWIDTH(16)
  ) mem (
      .data_out(data_out),
      .data_in(data_in),
      .addr(addr),
      .enable(enable),
      .wr(wr),
      .clk(clk),
      .rst(rst)
  );

endmodule  // memory1c_tb
