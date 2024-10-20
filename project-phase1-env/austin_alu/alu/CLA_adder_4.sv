module CLA_adder_4 (
    input [3:0] a,
    input [3:0] b,
    input c_in,
    output [3:0] sum,
    output ovfl,
    output cout,
    output TG,
    output TP
);

wire [3:0] p;
wire [3:0] g;
wire [2:0] carries;

//bitwise sum
assign p[0] = a[0] | b[0];
assign p[1] = a[1] | b[1];
assign p[2] = a[2] | b[2];
assign p[3] = a[3] | b[3];

//carry due to adding operands
assign g[0] = a[0] & b[0];
assign g[1] = a[1] & b[1];
assign g[2] = a[2] & b[2];
assign g[3] = a[3] & b[3];

assign carries[0] = g[0] | (p[0] & c_in);
assign carries[1] = g[1] | (p[1] & (g[0] | (p[0] & c_in)));
assign carries[2] = g[2] | (p[2] & g[1] | (p[1] & (g[0] | (p[0] & c_in))));
assign carries[3] = g[3] | (p[3] & (g[2] | (p[2] & g[1] | (p[1] & (g[0] | (p[0] & c_in))))));

//total carry propogated
assign TP = p[0] & p[1] & p[2] & p[3];
//total carry generated
assign TG = carries[3];

//full adder 
fa add_1(.a(a[0]),.b(b[0]),.c_in(c_in),.sum(sum[0]),.c_out());
fa add_2(.a(a[1]),.b(b[1]),.c_in(carries[0]),.sum(sum[1]),.c_out());
fa add_3(.a(a[2]),.b(b[2]),.c_in(carries[1]),.sum(sum[2]),.c_out());
fa add_4(.a(a[3]),.b(b[3]),.c_in(carries[2]),.sum(sum[3]),.c_out());

//overflow bit:
assign ovfl = (b[3] ~^ a[3]) & (sum[3] ^ a[3]);

//carry out:
assign cout = c[4];

endmodule
