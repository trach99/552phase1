module base3_conv(
	input [3:0] base2_in,
	output reg [5:0] base3_out
);

always@(*) begin
	case(base2_in)
		4'b0000: base3_out = 6'b000000; // 000
		4'b0001: base3_out = 6'b000001; // 001
		4'b0010: base3_out = 6'b000010; // 002
		4'b0011: base3_out = 6'b000100; // 010
		4'b0100: base3_out = 6'b000101; // 011
		4'b0101: base3_out = 6'b000110; // 012
		4'b0110: base3_out = 6'b001000; // 020
		4'b0111: base3_out = 6'b001001; // 021
		4'b1000: base3_out = 6'b001010; // 022
		4'b1001: base3_out = 6'b010000; // 100
		4'b1010: base3_out = 6'b010001; // 101
		4'b1011: base3_out = 6'b010010; // 102
		4'b1100: base3_out = 6'b010100; // 110
		4'b1101: base3_out = 6'b010101; // 111
		4'b1110: base3_out = 6'b010110; // 112
		4'b1111: base3_out = 6'b011000; // 120
	endcase
end


endmodule