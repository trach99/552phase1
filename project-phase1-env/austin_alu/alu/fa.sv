module fa(a,b,c_in,sum,c_out);

input a,b,c_in;
output sum,c_out;

wire p;
wire g;
wire c_out_2part;

assign p = a ^ b;
assign g = a & b;
assign c_out_2part = p & c_in;

assign sum = p ^ c_in;
assign c_out = g | c_out_2part;

endmodule
