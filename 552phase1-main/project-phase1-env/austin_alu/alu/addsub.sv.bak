module addsub_16bit(
    input [15:0] a,
    input [15:0] b,
    input c_in,
    output [15:0] sum,
    output ovfl
);

//respective total propogation for each 4bit block
wire [3:0] tp;
//respective total carry generate for each 4bit block
wire [3:0] tg;

//temperorary sum register
wire [15:0] sum_temp;

wire [15:0] b_in;
assign b_in = c_in ? ~b : b;

wire [3:0] c;
assign c[0] = tg[0] | (tp[0] & c_in);
assign c[1] = tg[1] | (tp[1] & c[0]);
assign c[2] = tg[2] | (tp[2] & c[1]);
assign c[3] = tg[3] | (tp[3] & c[2]);

//instantiate the duts:
CLA_adder_4 idut0(
    .a(a[3:0]),
    .b(b[3:0]),
    .c_in(c_in),
    .sum(sum_temp[3:0]),
    .ovfl(),
    .cout(),
    .TG(tg(0)),
    .TP(tp(0))
);


CLA_adder_4 idut1(
    .a(a[7:4]),
    .b(b[7:4]),
    .c_in(c[0]),
    .sum(sum_temp[7:4]),
    .ovfl(),
    .cout(),
    .TG(tg(1)),
    .TP(tp(1))
);
CLA_adder_4 idut2(
    .a(a[11:8]),
    .b(b[11:8]),
    .c_in(c[1]),
    .sum(sum_temp[11:8]),
    .ovfl(),
    .cout(),
    .TG(tg(2)),
    .TP(tp(2))
);
CLA_adder_4 idut3(
    .a(a[15:12]),
    .b(b[15:12]),
    .c_in(c[2]),
    .sum(sum_temp[15:12]),
    .ovfl(),
    .cout(),
    .TG(tg(3)),
    .TP(tp(3))
);

assign ovfl = (b[15] ~^ a[15]) & (sum[15] ^ a[15]);

//saturate
assign  sum = ovfl ? (c[3] ? 16'h8000 : 16'h7FFF) : sum_temp;

endmodule