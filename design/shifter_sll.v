module shifter_sll(
	input [15:0] a,
	input [5:0] base3_b,
	output [15:0] out
);


wire [15:0] shift_stage_1;
wire [15:0] shift_stage_2;
wire [15:0] shift_stage_3;

// Stage 1 shifting - Shifts by either 0, 1, 2 based on the input base3 shift val
assign shift_stage_1[0] = (base3_b[1:0] == 2'b10) ? 1'b0 : (base3_b[1:0] == 2'b01) ? 1'b0 : (base3_b[1:0] == 2'b00) ? a[0] : 2'bxx;
assign shift_stage_1[1] = (base3_b[1:0] == 2'b10) ? 1'b0 : (base3_b[1:0] == 2'b01) ? a[0] : (base3_b[1:0] == 2'b00) ? a[1] : 2'bxx;
assign shift_stage_1[2] = (base3_b[1:0] == 2'b10) ? a[0] : (base3_b[1:0] == 2'b01) ? a[1] : (base3_b[1:0] == 2'b00) ? a[2] : 2'bxx;
assign shift_stage_1[3] = (base3_b[1:0] == 2'b10) ? a[1] : (base3_b[1:0] == 2'b01) ? a[2] : (base3_b[1:0] == 2'b00) ? a[3] : 2'bxx;
assign shift_stage_1[4] = (base3_b[1:0] == 2'b10) ? a[2] : (base3_b[1:0] == 2'b01) ? a[3] : (base3_b[1:0] == 2'b00) ? a[4] : 2'bxx;
assign shift_stage_1[5] = (base3_b[1:0] == 2'b10) ? a[3] : (base3_b[1:0] == 2'b01) ? a[4] : (base3_b[1:0] == 2'b00) ? a[5] : 2'bxx;
assign shift_stage_1[6] = (base3_b[1:0] == 2'b10) ? a[4] : (base3_b[1:0] == 2'b01) ? a[5] : (base3_b[1:0] == 2'b00) ? a[6] : 2'bxx;
assign shift_stage_1[7] = (base3_b[1:0] == 2'b10) ? a[5] : (base3_b[1:0] == 2'b01) ? a[6] : (base3_b[1:0] == 2'b00) ? a[7] : 2'bxx;
assign shift_stage_1[8] = (base3_b[1:0] == 2'b10) ? a[6] : (base3_b[1:0] == 2'b01) ? a[7] : (base3_b[1:0] == 2'b00) ? a[8] : 2'bxx;
assign shift_stage_1[9] = (base3_b[1:0] == 2'b10) ? a[7] : (base3_b[1:0] == 2'b01) ? a[8] : (base3_b[1:0] == 2'b00) ? a[9] : 2'bxx;
assign shift_stage_1[10] = (base3_b[1:0] == 2'b10) ? a[8] : (base3_b[1:0] == 2'b01) ? a[9] : (base3_b[1:0] == 2'b00) ? a[10] : 2'bxx;
assign shift_stage_1[11] = (base3_b[1:0] == 2'b10) ? a[9] : (base3_b[1:0] == 2'b01) ? a[10]: (base3_b[1:0] == 2'b00) ? a[11] : 2'bxx;
assign shift_stage_1[12] = (base3_b[1:0] == 2'b10) ? a[10] : (base3_b[1:0] == 2'b01) ? a[11] : (base3_b[1:0] == 2'b00) ? a[12] : 2'bxx;
assign shift_stage_1[13] = (base3_b[1:0] == 2'b10) ? a[11] : (base3_b[1:0] == 2'b01) ? a[12] : (base3_b[1:0] == 2'b00) ? a[13] : 2'bxx;
assign shift_stage_1[14] = (base3_b[1:0] == 2'b10) ? a[12] : (base3_b[1:0] == 2'b01) ? a[13] : (base3_b[1:0] == 2'b00) ? a[14] : 2'bxx;
assign shift_stage_1[15] = (base3_b[1:0] == 2'b10) ? a[13] : (base3_b[1:0] == 2'b01) ? a[14] : (base3_b[1:0] == 2'b00) ? a[15] : 2'bxx;

// Stage 2 shifting - Shifts by either 0, 3, 6 based on the input base3 shift val
assign shift_stage_2[0] = (base3_b[3:2] == 2'b10) ? 1'b0 : (base3_b[3:2] == 2'b01) ? 1'b0 : (base3_b[3:2] == 2'b00) ? shift_stage_1[0] : 2'bxx;
assign shift_stage_2[1] = (base3_b[3:2] == 2'b10) ? 1'b0 : (base3_b[3:2] == 2'b01) ? 1'b0 : (base3_b[3:2] == 2'b00) ? shift_stage_1[1] : 2'bxx;
assign shift_stage_2[2] = (base3_b[3:2] == 2'b10) ? 1'b0 : (base3_b[3:2] == 2'b01) ? 1'b0 : (base3_b[3:2] == 2'b00) ? shift_stage_1[2] : 2'bxx;
assign shift_stage_2[3] = (base3_b[3:2] == 2'b10) ? 1'b0 : (base3_b[3:2] == 2'b01) ? shift_stage_1[0] : (base3_b[3:2] == 2'b00) ? shift_stage_1[3] : 2'bxx;
assign shift_stage_2[4] = (base3_b[3:2] == 2'b10) ? 1'b0 : (base3_b[3:2] == 2'b01) ? shift_stage_1[1] : (base3_b[3:2] == 2'b00) ? shift_stage_1[4] : 2'bxx;
assign shift_stage_2[5] = (base3_b[3:2] == 2'b10) ? 1'b0 : (base3_b[3:2] == 2'b01) ? shift_stage_1[2] : (base3_b[3:2] == 2'b00) ? shift_stage_1[5] : 2'bxx;
assign shift_stage_2[6] = (base3_b[3:2] == 2'b10) ? shift_stage_1[0] : (base3_b[3:2] == 2'b01) ? shift_stage_1[3] : (base3_b[3:2] == 2'b00) ? shift_stage_1[6] : 2'bxx;
assign shift_stage_2[7] = (base3_b[3:2] == 2'b10) ? shift_stage_1[1] : (base3_b[3:2] == 2'b01) ? shift_stage_1[4] : (base3_b[3:2] == 2'b00) ? shift_stage_1[7] : 2'bxx;
assign shift_stage_2[8] = (base3_b[3:2] == 2'b10) ? shift_stage_1[2] : (base3_b[3:2] == 2'b01) ? shift_stage_1[5] : (base3_b[3:2] == 2'b00) ? shift_stage_1[8] : 2'bxx;
assign shift_stage_2[9] = (base3_b[3:2] == 2'b10) ? shift_stage_1[3] : (base3_b[3:2] == 2'b01) ? shift_stage_1[6] : (base3_b[3:2] == 2'b00) ? shift_stage_1[9] : 2'bxx;
assign shift_stage_2[10] = (base3_b[3:2] == 2'b10) ? shift_stage_1[4] : (base3_b[3:2] == 2'b01) ? shift_stage_1[7] : (base3_b[3:2] == 2'b00) ? shift_stage_1[10] : 2'bxx;
assign shift_stage_2[11] = (base3_b[3:2] == 2'b10) ? shift_stage_1[5] : (base3_b[3:2] == 2'b01) ? shift_stage_1[8]: (base3_b[3:2] == 2'b00) ? shift_stage_1[11] : 2'bxx;
assign shift_stage_2[12] = (base3_b[3:2] == 2'b10) ? shift_stage_1[6] : (base3_b[3:2] == 2'b01) ? shift_stage_1[9] : (base3_b[3:2] == 2'b00) ? shift_stage_1[12] : 2'bxx;
assign shift_stage_2[13] = (base3_b[3:2] == 2'b10) ? shift_stage_1[7] : (base3_b[3:2] == 2'b01) ? shift_stage_1[10] : (base3_b[3:2] == 2'b00) ? shift_stage_1[13] : 2'bxx;
assign shift_stage_2[14] = (base3_b[3:2] == 2'b10) ? shift_stage_1[8] : (base3_b[3:2] == 2'b01) ? shift_stage_1[11] : (base3_b[3:2] == 2'b00) ? shift_stage_1[14] : 2'bxx;
assign shift_stage_2[15] = (base3_b[3:2] == 2'b10) ? shift_stage_1[9] : (base3_b[3:2] == 2'b01) ? shift_stage_1[12] : (base3_b[3:2] == 2'b00) ? shift_stage_1[15] : 2'bxx;

// Stage 3 shifting - Shifts by either 0, 9, 18 based on the input base3 shift val. In our case we only shift a maximum of 9 bits.
assign shift_stage_3[0] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? 1'b0 : (base3_b[5:4] == 2'b00) ? shift_stage_2[0] : 2'bxx;
assign shift_stage_3[1] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? 1'b0 : (base3_b[5:4] == 2'b00) ? shift_stage_2[1] : 2'bxx;
assign shift_stage_3[2] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? 1'b0 : (base3_b[5:4] == 2'b00) ? shift_stage_2[2] : 2'bxx;
assign shift_stage_3[3] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? 1'b0 : (base3_b[5:4] == 2'b00) ? shift_stage_2[3] : 2'bxx;
assign shift_stage_3[4] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? 1'b0 : (base3_b[5:4] == 2'b00) ? shift_stage_2[4] : 2'bxx;
assign shift_stage_3[5] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? 1'b0 : (base3_b[5:4] == 2'b00) ? shift_stage_2[5] : 2'bxx;
assign shift_stage_3[6] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? 1'b0 : (base3_b[5:4] == 2'b00) ? shift_stage_2[6] : 2'bxx;
assign shift_stage_3[7] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? 1'b0 : (base3_b[5:4] == 2'b00) ? shift_stage_2[7] : 2'bxx;
assign shift_stage_3[8] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? 1'b0 : (base3_b[5:4] == 2'b00) ? shift_stage_2[8] : 2'bxx;
assign shift_stage_3[9] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? shift_stage_2[0] : (base3_b[5:4] == 2'b00) ? shift_stage_2[9] : 2'bxx;
assign shift_stage_3[10] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? shift_stage_2[1] : (base3_b[5:4] == 2'b00) ? shift_stage_2[10] : 2'bxx;
assign shift_stage_3[11] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? shift_stage_2[2]: (base3_b[5:4] == 2'b00) ? shift_stage_2[11] : 2'bxx;
assign shift_stage_3[12] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? shift_stage_2[3] : (base3_b[5:4] == 2'b00) ? shift_stage_2[12] : 2'bxx;
assign shift_stage_3[13] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? shift_stage_2[4] : (base3_b[5:4] == 2'b00) ? shift_stage_2[13] : 2'bxx;
assign shift_stage_3[14] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? shift_stage_2[5] : (base3_b[5:4] == 2'b00) ? shift_stage_2[14] : 2'bxx;
assign shift_stage_3[15] = (base3_b[5:4] == 2'b10) ? 1'b0 : (base3_b[5:4] == 2'b01) ? shift_stage_2[6] : (base3_b[5:4] == 2'b00) ? shift_stage_2[15] : 2'bxx;

assign out = shift_stage_3;
endmodule
