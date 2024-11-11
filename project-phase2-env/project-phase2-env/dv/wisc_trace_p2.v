// WISC Trace P2 - CPU Stats & Logging

module wisc_trace_p2 #(
    parameter ARCH_WIDTH = 16,
    parameter REG_WIDTH  = 4
) (
    input clk,
    input rst,
    input Halt,
    input [ARCH_WIDTH-1:0] PC,
    input [ARCH_WIDTH-1:0] Inst,  // The 16 bit instruction word
    input RegWrite,  // True if RF is being written
    input [REG_WIDTH-1:0] WriteRegister,  // What 4-bit register number is written when RegWrite==1
    input [ARCH_WIDTH-1:0] WriteData,  // 16-bit Data being written to the RF when RegWrite==1
    input MemRead,  // True if memory is being read
    input MemWrite,  // True if memory is being written
    input [ARCH_WIDTH-1:0] MemAddress,  // DataMemAddress being written
    input [ARCH_WIDTH-1:0] MemDataIn,  // Data being written when RegWrite==1
    input [ARCH_WIDTH-1:0] MemDataOut  // Data being read when RegRead==1
);

  // Setup
  integer inst_count;
  integer cycle_count;
  integer trace_file;
  integer sim_log_file;
  initial begin
    cycle_count = 0;
    $dumpvars;
    $display("Simulation starting");
    $display("See verilogsim.log and verilogsim.trace for output");
    inst_count   = 0;
    trace_file   = $fopen("verilogsim.trace");
    sim_log_file = $fopen("verilogsim.log");
  end

  always @(posedge clk) begin
    cycle_count <= cycle_count + 1;
    if (cycle_count > 100000) begin
      $display("hmm....more than 100000 cycles of simulation...error?\n");
      $finish;
    end
  end

  always @(posedge clk) begin
    if (!rst) begin
      if (Halt || RegWrite || MemWrite) begin
        inst_count <= inst_count + 1;
      end
      $fdisplay(sim_log_file, "SIMLOG:: Cycle %d PC: %8x I: %8x R: %d %3d %8x M: %d %d %8x %8x %8x",
                cycle_count, PC, Inst, RegWrite, WriteRegister, WriteData, MemRead, MemWrite,
                MemAddress, MemDataIn, MemDataOut);
      if (RegWrite) begin
        $fdisplay(trace_file, "REG: %d VALUE: 0x%04x", WriteRegister, WriteData);
      end
      if (MemRead) begin
        $fdisplay(trace_file, "LOAD: ADDR: 0x%04x VALUE: 0x%04x", MemAddress, MemDataOut);
      end

      if (MemWrite) begin
        $fdisplay(trace_file, "STORE: ADDR: 0x%04x VALUE: 0x%04x", MemAddress, MemDataIn);
      end
      if (Halt) begin
        $fdisplay(sim_log_file, "SIMLOG:: Processor halted\n");
        $fdisplay(sim_log_file, "SIMLOG:: sim_cycles %d\n", cycle_count);
        $fdisplay(sim_log_file, "SIMLOG:: inst_count %d\n", inst_count);

        $fclose(trace_file);
        $fclose(sim_log_file);
        #5;
        $finish;
      end
    end
  end
endmodule  // wisc_trace_p2
