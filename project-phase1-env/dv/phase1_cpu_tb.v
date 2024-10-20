`timescale 1ns / 1ps

// Top-level testbench for ECE 552 cpu.v
module phase1_cpu_tb ();
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

  // Setup
  integer inst_count;
  integer cycle_count;
  integer trace_file;
  integer sim_log_file;
  initial begin
    $dumpvars;
    $display("Simulation starting");
    $display("See verilogsim.log and verilogsim.trace for output");
    inst_count   = 0;
    trace_file   = $fopen("verilogsim.trace");
    sim_log_file = $fopen("verilogsim.log");
  end

  // Clock period is 100 time units, and reset length
  // to 201 time units (two rising edges of clock).
  initial begin
    cycle_count = 0;
    rst = 1;  /* Intial reset state */
    #201 rst = 0;  // delay until slightly after two clock periods
  end

  initial begin
    clk = 1;
    forever #half_cycle clk = ~clk;
  end

  always @(posedge clk) begin
    cycle_count = cycle_count + 1;
    if (cycle_count > 100000) begin
      $display("hmm....more than 100000 cycles of simulation...error?\n");
      $finish;
    end
  end

  // Assign internal signals to top level wires.
  // Edit the example below. You must change the signal names on the right hand side to match your naming convention.
  wire [15:0] Inst = DUT.instr;  // The 16 bit instruction word.
  wire RegWrite = DUT.write_reg;  // Whether or not register file is being written
  wire [3:0] WriteRegister = DUT.dst_reg;  // What 4-bit register number is written
  wire [15:0] WriteData = DUT.dst_data;  // 16-bit Data being written to the registerfile.
  wire MemWrite = (DUT.data_mem.enable & DUT.data_mem.wr);  // Memory is being Written
  wire MemRead = DUT.data_mem.data_out;  // Memory is being Read
  wire [15:0] MemAddress = DUT.data_mem.addr;  // 16-bit memory address being accessed
  wire [15:0] MemData = DUT.data_mem.data_in;  // Data written to Memory on memory writes.

  /* Add anything else you want here */

  /* Stats */
  always @(posedge clk) begin
    if (!rst) begin
      if (Halt || RegWrite || MemWrite) begin
        inst_count = inst_count + 1;
      end
      $fdisplay(sim_log_file, "SIMLOG:: Cycle %d PC: %8x I: %8x R: %d %3d %8x M: %d %d %8x %8x",
                cycle_count, PC, Inst, RegWrite, WriteRegister, WriteData, MemRead, MemWrite,
                MemAddress, MemData);
      if (RegWrite) begin
        if (MemRead) begin
          // ld
          $fdisplay(trace_file, "INUM: %8d PC: 0x%04x REG: %d VALUE: 0x%04x ADDR: 0x%04x",
                    (inst_count - 1), PC, WriteRegister, WriteData, MemAddress);
        end else begin
          $fdisplay(trace_file, "INUM: %8d PC: 0x%04x REG: %d VALUE: 0x%04x", (inst_count - 1), PC,
                    WriteRegister, WriteData);
        end
      end else if (Halt) begin
        $fdisplay(sim_log_file, "SIMLOG:: Processor halted\n");
        $fdisplay(sim_log_file, "SIMLOG:: sim_cycles %d\n", cycle_count);
        $fdisplay(sim_log_file, "SIMLOG:: inst_count %d\n", inst_count);
        $fdisplay(trace_file, "INUM: %8d PC: 0x%04x", (inst_count - 1), PC);

        $fclose(trace_file);
        $fclose(sim_log_file);

				$writememh("dumpfile_data.img", DUT.data_mem.mem);
        $finish;
      end else begin
        if (MemWrite) begin
          // st
          $fdisplay(trace_file, "INUM: %8d PC: 0x%04x ADDR: 0x%04x VALUE: 0x%04x",
                    (inst_count - 1), PC, MemAddress, MemData);
        end else begin
          // conditional branch or NOP
          // Need better checking in pipelined testbench
          inst_count = inst_count + 1;
          $fdisplay(trace_file, "INUM: %8d PC: 0x%04x", (inst_count - 1), PC);
        end
      end
    end

  end


endmodule
