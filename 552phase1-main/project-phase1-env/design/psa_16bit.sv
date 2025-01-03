module psa_16bit (
  input  [15:0] a, // input A
  input  [15:0] b, // input B
  output [15:0] sum, // sum output
  output        error // indicates 1+ overflows
);
wire [3:0] error_4bit;
wire [15:0] sum_temp;
wire [3:0] cout;

//instantiate the dut

/*
-------------------------------------------------
module adder_4bit (
    input [3:0]  a, // input A
    input [3:0]  b, // input B
    input        is_sub, // 1==subtract
    output [3:0] sum, // sum output
    output       ovfl // indicate overflow
);
-------------------------------------------------
*/

CLA_adder_4 idut1(.a(a[15:12]),.b(b[15:12]),.sum(sum_temp[15:12]),.ovfl(error_4bit[3]),.c_in(1'b0),.cout(cout[3]),.TG(),.TP());
CLA_adder_4 idut2(.a(a[11:8]),.b(b[11:8]),.sum(sum_temp[11:8]),.ovfl(error_4bit[2]),.c_in(1'b0),.cout(cout[2]),.TG(),.TP());
CLA_adder_4 idut3(.a(a[7:4]),.b(b[7:4]),.sum(sum_temp[7:4]),.ovfl(error_4bit[1]),.c_in(1'b0),.cout(cout[1]),.TG(),.TP());
CLA_adder_4 idut4(.a(a[3:0]),.b(b[3:0]),.sum(sum_temp[3:0]),.ovfl(error_4bit[0]),.c_in(1'b0),.cout(cout[0]),.TG(),.TP());

assign error = |error_4bit;

//saturate each sub additions results
assign sum[15:12] = error_4bit[3] ? (cout[3] ? 4'hF : 4'h7) : sum_temp[15:12];
assign sum[11:8] = error_4bit[2] ? (cout[2] ? 4'hF : 4'h7) : sum_temp[11:8];
assign sum[7:4] = error_4bit[1] ? (cout[1] ? 4'hF : 4'h7) : sum_temp[7:4];
assign sum[3:0] = error_4bit[0] ? (cout[0] ? 4'hF : 4'h7) : sum_temp[3:0];

endmodule