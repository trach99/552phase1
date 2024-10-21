`timescale 1ns / 1ps

module CPU_control_tb;

  reg [15:12] opc;
  wire halt, RegDst, ALUSrc, MemRead, MemWrite, MemtoReg, RegWrite, Lower, Higher, BEn, Br, PCS;

  // Instantiate the CPU_control module
  CPU_control dut (
    .opc(opc),
    .halt(halt),
    .RegDst(RegDst),
    .ALUSrc(ALUSrc),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .Lower(Lower),
    .Higher(Higher),
    .BEn(BEn),
    .Br(Br),
    .PCS(PCS)
  );

  // Task to check outputs against expected values
  task check_outputs(
    input [15:12] test_opc,
    input expected_halt,
    input expected_RegDst,
    input expected_ALUSrc,
    input expected_MemRead,
    input expected_MemWrite,
    input expected_MemtoReg,
    input expected_RegWrite,
    input expected_Lower,
    input expected_Higher,
    input expected_BEn,
    input expected_Br,
    input expected_PCS
  );
    begin
      opc = test_opc;
      #10; // Wait for the outputs to stabilize
      
      // Check outputs
      if (halt !== expected_halt) $display("Error: OPC=%b, Expected halt=%b, Got halt=%b", test_opc, expected_halt, halt);
      if (RegDst !== expected_RegDst) $display("Error: OPC=%b, Expected RegDst=%b, Got RegDst=%b", test_opc, expected_RegDst, RegDst);
      if (ALUSrc !== expected_ALUSrc) $display("Error: OPC=%b, Expected ALUSrc=%b, Got ALUSrc=%b", test_opc, expected_ALUSrc, ALUSrc);
      if (MemRead !== expected_MemRead) $display("Error: OPC=%b, Expected MemRead=%b, Got MemRead=%b", test_opc, expected_MemRead, MemRead);
      if (MemWrite !== expected_MemWrite) $display("Error: OPC=%b, Expected MemWrite=%b, Got MemWrite=%b", test_opc, expected_MemWrite, MemWrite);
      if (MemtoReg !== expected_MemtoReg) $display("Error: OPC=%b, Expected MemtoReg=%b, Got MemtoReg=%b", test_opc, expected_MemtoReg, MemtoReg);
      if (RegWrite !== expected_RegWrite) $display("Error: OPC=%b, Expected RegWrite=%b, Got RegWrite=%b", test_opc, expected_RegWrite, RegWrite);
      if (Lower !== expected_Lower) $display("Error: OPC=%b, Expected Lower=%b, Got Lower=%b", test_opc, expected_Lower, Lower);
      if (Higher !== expected_Higher) $display("Error: OPC=%b, Expected Higher=%b, Got Higher=%b", test_opc, expected_Higher, Higher);
      if (BEn !== expected_BEn) $display("Error: OPC=%b, Expected BEn=%b, Got BEn=%b", test_opc, expected_BEn, BEn);
      if (Br !== expected_Br) $display("Error: OPC=%b, Expected Br=%b, Got Br=%b", test_opc, expected_Br, Br);
      if (PCS !== expected_PCS) $display("Error: OPC=%b, Expected PCS=%b, Got PCS=%b", test_opc, expected_PCS, PCS);
    end
  endtask

  initial begin
    // Test cases
    check_outputs(4'b00_00, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0); // ADD, SUB, XOR, RED
    check_outputs(4'b0111, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0); // PADDSB
    check_outputs(4'b01_00, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0); // SLL, SRA, ROR
    check_outputs(4'b1000, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0); // LW
    check_outputs(4'b1001, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0); // SW
    check_outputs(4'b1010, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0); // LLB
    check_outputs(4'b1011, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0); // LHB
    check_outputs(4'b1100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0); // B
    check_outputs(4'b1101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0); // BR
    check_outputs(4'b1110, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1); // PCS
    check_outputs(4'b1111, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // HLT
    check_outputs(4'bxxxx, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); // Default case
    
    // End of simulation
    //$finish;
  end

endmodule

