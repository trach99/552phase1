module Shifter_16bit(
	input[15:0] Shift_In, // Value that is being shifted
	input [3:0] Shift_Val, // By what value is it being shifter
	input [1:0] Mode_In, // 00 - SLL, 01 - SRA, 10 - ROR; These values are based on project documents
	output [15:0] Shift_Out
	// output zero,
	// output sign,
	// output ovfl
);

// Two bits of base3_b represents 1 bit of a base3 number. Ex. (2)base3 = (10)base2; (21)base3 = (10 01)base2
wire [5:0] base3_b; // Holds the base3 number but in binary format
wire [15:0] sll_result;
wire [15:0] sra_result;
wire [15:0] ror_result;

// Mapping base2 numbers to base3 numbers
base3_conv iCONV(.base2_in(Shift_Val), .base3_out(base3_b));

// SLL Operation
shifter_sll iSLL(.a(Shift_In), .base3_b(base3_b), .out(sll_result));
// SRA Operation
shifter_sra iSRA(.a(Shift_In), .base3_b(base3_b), .out(sra_result));
// ROR Operation
shifter_ror iROR(.a(Shift_In), .base3_b(base3_b), .out(ror_result));

assign Shift_Out = (Mode_In == 2'b00) ? sll_result : (Mode_In == 2'b01) ? sra_result : (Mode_In == 2'b10) ? ror_result : 16'hxxxx;

// assign zero = !(|Shift_Out);
// assign sign = 1'bz;
// assign ovfl = 1'bz;

endmodule
