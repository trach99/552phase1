module alu(ALU_Out, ALU_In1, ALU_In2, Opcode,Flags, en);

input [15:0] ALU_In1;
input [15:0] ALU_In2;
input [3:0] Opcode;
output [15:0] ALU_Out;
output [2:0] Flags;
output [2:0] en;

wire [15:0] Sum;
wire [15:0] shift_out;
wire [15:0] Diff, PADDSB;
wire [15:0] Exor;
wire [15:0] Red;
wire OvflAdd,OvflSub;

addsub add(.a(ALU_In1), .b(ALU_In2), .sum(Sum), .ovfl(OvflAdd), .sub(1'b0));
addsub sub(.a(ALU_In1), .b(ALU_In2), .sum(Diff), .ovfl(OvflSub), .sub(1'b1));
red redUnit(.a(ALU_In1), .b(ALU_In2), .sum(Red));
paddsb paddsb(.Sum(PADDSB), .A(ALU_In1), .B(ALU_In2));
shifter shifter(.opcode(Opcode[1:0]), .result(shift_out), .a(ALU_In1), .b(ALU_In2));

assign Exor =  ALU_In1 ^ ALU_In2;

reg [2:0] enable;

/*ZVN*/
always @* case (Opcode)
4'h0 : begin 
	assign enable = 3'b111;
	end
4'h1 : begin	
	assign enable = 3'b111;
	end
4'h2 : begin
	assign enable = 3'b100;
	end
4'h3 : begin
	assign enable = 3'b100;
	end
4'h4 : begin
	assign enable = 3'b100;
	end
4'h5 : begin
	assign enable = 3'b100;
	end
4'h6 : begin
	assign enable = 3'b100;
	end
4'h7 : begin
	assign enable = 3'b100;
	end
default: assign enable = 3'b000;
endcase

assign ALU_Out = (Opcode == 4'h0) ? Sum:
				 (Opcode == 4'h1) ? Diff:
				 (Opcode == 4'h2) ? Exor:
				 (Opcode == 4'h3) ? Red:
				 (Opcode == 4'h4) ? shift_out:
				 (Opcode == 4'h5) ? shift_out:
				 (Opcode == 4'h6) ? shift_out: 
				 (Opcode == 4'h7) ? PADDSB : 
				 (Opcode == 4'h8) ? Sum :
				 (Opcode == 4'h9) ? Sum : 
				 ALU_In1 | ALU_In2; 		/* LLB or HHB storing(OR) immediate to the LSB 8 or MSB 8, respectively*/
/*Overflow - V*/
assign Flags[1] = ((Opcode == 4'h0)& (OvflAdd == 1'b1)) ? 1'b1:
		   ((Opcode == 4'h1) & (OvflSub == 1'b1)) ? 1'b1: 1'b0;
/*Negative - N*/
assign Flags[0] = ((Opcode == 4'h0)& (Sum[15] == 1'b1)) ? 1'b1:
		   ((Opcode == 4'h1) & (Diff[15] == 1'b1)) ? 1'b1: 1'b0;
/*Zero - Z*/
assign Flags[2] = (ALU_Out == 16'h0000);

assign en = enable;

endmodule
