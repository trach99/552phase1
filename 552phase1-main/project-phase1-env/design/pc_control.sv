module pc_control (
    input [2:0] c, /*condition*/
    input [2:0] f, /*flag reg*/
    input branch,
    input branchreg,
    input [15:0]branchreg_reg1, /*contents of Rs register for branchreg instructions*/ 
    input [8:0]opcode_immd, /*offset*/
    input [15:0] curr_addr,
    output [15:0] nxt_addr
);

wire [15:0] curr_addr_add2; /*normal +2 increment*/
wire [15:0] curr_addr_immd; /*immediate +2 increment*/
wire condition_met; /*result of branching condition evaluation*/

/*adding 2 to the current address*/
addsub_16bit add2(
    .a(curr_addr),
    .b(16'h2),
    .c_in(1'b0),
    .sum(curr_addr_add2),
    .ovfl()
);

/*left shift immediate by 1 (byte addressable memory, each address 2 bytes)*/
wire [15:0] opcode_immd_signed;
wire [15:0] shifted_final_immd;
assign opcode_immd_signed = {{7{opcode_immd[8]}},opcode_immd};
assign shifted_final_immd = opcode_immd_signed << 1;

/*adding immediate to current address + 2*/
addsub_16bit addimmd(
    .a(curr_addr_add2),
    .b(shifted_final_immd),
    .c_in(1'b0),
    .sum(curr_addr_immd),
    .ovfl()
);

/*FLAG Management*/
wire Z, V, N;
assign Z = f[2];
assign V = f[1];
assign N = f[0];


/*****************************************
 CONDITION MANAGEMENT
 *****************************************/

assign condition_met = 
    (c == 3'h0 && Z == 1'b0) ||
    (c == 3'h1 && Z == 1'b1) ||
    (c == 3'h2 && (Z == 1'b0 && N == 1'b0)) ||
    (c == 3'h3 && N == 1'b1) ||
    (c == 3'h4 && (Z==1'b1 | (Z == 1'b0 && N == 1'b0))) ||
    (c == 3'h5 && (N == 1'b1 | Z == 1'b1)) ||
    (c == 3'h6  && V == 1'b1) ||
    (c == 3'h7);
/*****************************************/

/*branch only if (branch enabled or branchreg enabled) and condition met*/
assign nxt_addr = branch && condition_met ? curr_addr_immd:
                    branchreg && condition_met ? branchreg_reg1:
                        curr_addr_add2;


endmodule