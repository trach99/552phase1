module shifter (
    input [1:0] opcode,
    input [15:0] a,//rs register
    input [15:0] b,//rt/immediate register
    output  [15:0] result //rd register
);

//Opcode rd, rs, imm
//rs >> imm(4bits)
// temp shift registers for each 4 bits
reg [15:0] sr_0;
reg [15:0] sr_1;
reg [15:0] sr_2;
reg [15:0] sr_3;

//only bothered with 2 LSB
// SLL 01 00
// SRA 01 01
// ROR 01 10

always @(*) begin
    case (opcode)
        2'b00: begin
            sr_0 = b[0] ? a << 1 : a;
            sr_1 = b[1] ? sr_0 << 2 : sr_0;
            sr_2 = b[2] ? sr_1 << 4 : sr_1;
            sr_3 = b[3] ? sr_2 << 8 : sr_2; 
        end
        2'b01 : begin
           sr_0 = b[0] ? {a[15],a[15:1]} : a;
           sr_1 = b[1] ? {{2{sr_0[15]}},sr_0[15:2]} : sr_0;
           sr_2 = b[2] ? {{4{sr_1[15]}},sr_1[15:4]} : sr_1;
           sr_3 = b[3] ? {{8{sr_1[15]}},sr_2[15:8]} : sr_2;
        end
        2'b10 : begin
            sr_0 = b[0] ? {a[0],a[15:1]} : a;
            sr_1 = b[1] ? {sr_0[1:0],sr_0[15:2]} : sr_0;
            sr_2 = b[2] ? {sr_1[3:0],sr_1[15:4]} : sr_1;
            sr_3 = b[3] ? {sr_2[7:0],sr_2[15:8]} : sr_2;
        end
        default: 
            sr_3 = a;
    endcase
end
//finally store in output register
assign result = sr_3;

endmodule