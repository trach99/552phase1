// Top-level testbench for ECE 552 cpu.v Phase 2
module phase3_cpu_tb ();
  localparam half_cycle = 50;

  // Signals that interface to the DUT.
  wire [15:0] PC;
  wire Halt;  /* Halt executed and in Memory or writeback stage */
  reg clk;  /* Clock input */
  reg rst;  /* (Active high) Reset input */

  // Instantiate the processor as Design Under Test.
  cpu DUT (
      .clk(clk),
      .rst(rst),
      .pc (PC),
      .hlt(Halt)
  );

  initial begin
    clk <= 1;
    forever #half_cycle clk <= ~clk;
  end

  initial begin
    rst <= 1;  /* Intial reset state */
    repeat (3) @(negedge clk);
    rst <= 0;
  end

  // Assign internal signals - See wisc_trace_p3.v for instructions.
  // Edit the example below. You must change the signal names on the right hand side to match your naming convention.
  wisc_trace_p3 wisc_trace_p3 (
      .clk(clk),
      .rst(rst),
      .PC(PC),
      .Halt(Halt),
      .Inst(DUT.Inst),
      .RegWrite(DUT.MEM_WB_RegWrite),
      .WriteRegister(DUT.MEM_WB_RdAddr),
      .WriteData(DUT.DstData),
      .MemRead(DUT.EX_MEM_MemRead),
      .MemWrite(DUT.EX_MEM_MemWrite),
      .MemAddress(DUT.EX_MEM_ALUOut),
      .MemDataIn(DUT.DataIn_DA),
      .MemDataOut(DUT.Dmem_out),
      .icache_req(DUT.Inst_MDA_DA.hit),
      .icache_hit(DUT.Inst_MDA_DA.hit),
      .dcache_req(DUT.Data_MDA_DA.hit),
      .dcache_hit(DUT.Data_MDA_DA.hit)
  );

  /* Add anything else you want here */

endmodule
