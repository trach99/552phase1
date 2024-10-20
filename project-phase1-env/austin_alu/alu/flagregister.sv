module flagregister (
    input clk,
    input rst,
    input [2:0]d,
    input [2:0]e,
    output [2:0]q,
);

/*****************************************
 3 bit storage 2[ZVN]0
 *****************************************/
/*Negative - N*/
dff f_0(
    .q(q[0]),  // DFF output
    .d(d[0]),  // DFF input
    .wen(e[0]),  // Write Enable
    .clk(clk),
    .rst(rst)  // synchronous reset
);
/*Overflow - V*/
dff f_1(
    .q(q[1]),  // DFF output
    .d(d[1]),  // DFF input
    .wen(e[1]),  // Write Enable
    .clk(clk),
    .rst(rst)  // synchronous reset
);
/*Zero - Z*/
dff f_2(
    .q(q[2]),  // DFF output
    .d(d[2]),  // DFF input
    .wen(e[2]),  // Write Enable
    .clk(clk),
    .rst(rst)  // synchronous reset
);
/*****************************************/
    
endmodule