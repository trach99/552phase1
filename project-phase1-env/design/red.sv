module red (
    input  [15:0] a,
    input [15:0] b,
    output [15:0] sumfinal
);

//suma = a_MSB8 + a_LSB8;
wire [8:0] suma;
wire c1_a;
wire c2_a;
//sumb = b_MSB8 + b_LSB8;
wire [8:0] sumb;
wire c1_b;
wire c2_b;
//final_sum
wire c1_sf;
wire c2_sf;

//----a begins----//
CLA_adder_4 sa_0(
    .a(a[3:0]),
    .b(a[11:8]),
    .c_in(1'b0),
    .sum(suma[3:0]),
    .ovfl(),
    .cout(c1_a),
    .TG(),
    .TP()
);
CLA_adder_4 sa_1(
    .a(a[7:4]),
    .b(a[15:12]),
    .c_in(c1_a),
    .sum(suma[7:4]),
    .ovfl(),
    .cout(c2_a),
    .TG(),
    .TP()
);

assign suma[8] = a[7] ^ a[15] ^ c2_a;
//---a ends---//


//----b begins----//
CLA_adder_4 sb_0(
    .a(b[3:0]),
    .b(b[11:8]),
    .c_in(1'b0),
    .sum(sumb[3:0]),
    .ovfl(),
    .cout(c1_b),
    .TG(),
    .TP()
);
CLA_adder_4 sb_1(
    .a(b[7:4]),
    .b(b[15:12]),
    .c_in(c1_b),
    .sum(sumb[7:4]),
    .ovfl(),
    .cout(c2_b),
    .TG(),
    .TP()
);

assign sumb[8] = b[7] ^ b[15] ^ c2_b;
//---b ends---//

//final sum computation:
CLA_adder_4 sum_0(
    .a(suma[3:0]),
    .b(sumb[3:0]),
    .c_in(1'b0),
    .sum(sumfinal[3:0]),
    .ovfl(),
    .cout(c1_sf),
    .TG(),
    .TP()
);
CLA_adder_4 sum_1(
    .a(suma[7:4]),
    .b(sumb[7:4]),
    .c_in(c1_sf),
    .sum(sumfinal[7:4]),
    .ovfl(),
    .cout(c2_sf),
    .TG(),
    .TP()
);

wire [3:0]temp_s;
CLA_adder_4 sum_2(
    .a({4{suma[8]}}),        //sign extending first addition result
    .b({4{sumb[8]}}),        //sign extending second addition result
    .c_in(c2_sf),
    .sum(temp_s),
    .ovfl(),
    .cout(),
    .TG(),
    .TP()
);

assign sumfinal[8] = temp_s[0]; // result of all 3 carries (suma, sumb and carry from (suma + sumb))
assign sumfinal[15:9] = {7{temp_s[1]}}; //sign extending 9th index bit(addition of sign extension bits of suma, sumb )
//--final-sum ends----//

endmodule