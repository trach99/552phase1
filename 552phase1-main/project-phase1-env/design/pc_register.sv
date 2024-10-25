module pc_register (
    input clk,
    input rst,
    input e,
    input [15:0]d,
    output [15:0]q
);

/*****************************************
 16 bit address stored on 16 dffs
 *****************************************/

dff d0(.q(q[0]), .d(d[0]), .wen(e), .clk(clk), .rst(rst));
dff d1(.q(q[1]), .d(d[1]), .wen(e), .clk(clk), .rst(rst));
dff d2(.q(q[2]), .d(d[2]), .wen(e), .clk(clk), .rst(rst));
dff d3(.q(q[3]), .d(d[3]), .wen(e), .clk(clk), .rst(rst));
dff d4(.q(q[4]), .d(d[4]), .wen(e), .clk(clk), .rst(rst));
dff d5(.q(q[5]), .d(d[5]), .wen(e), .clk(clk), .rst(rst));
dff d6(.q(q[6]), .d(d[6]), .wen(e), .clk(clk), .rst(rst));
dff d7(.q(q[7]), .d(d[7]), .wen(e), .clk(clk), .rst(rst));
dff d8(.q(q[8]), .d(d[8]), .wen(e), .clk(clk), .rst(rst));
dff d9(.q(q[9]), .d(d[9]), .wen(e), .clk(clk), .rst(rst));
dff d10(.q(q[10]), .d(d[10]), .wen(e), .clk(clk), .rst(rst));
dff d11(.q(q[11]), .d(d[11]), .wen(e), .clk(clk), .rst(rst));
dff d12(.q(q[12]), .d(d[12]), .wen(e), .clk(clk), .rst(rst));
dff d13(.q(q[13]), .d(d[13]), .wen(e), .clk(clk), .rst(rst));
dff d14(.q(q[14]), .d(d[14]), .wen(e), .clk(clk), .rst(rst));
dff d15(.q(q[15]), .d(d[15]), .wen(e), .clk(clk), .rst(rst));


endmodule