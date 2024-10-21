module cpu(
    input clk,
    input rst,
    output hlt,
    output [15:0] pc
);


//ALL DECLARATIONS
/*pc counter currently points to instruction at this address*/
wire [15:0] curr_addr;
/*next address storage for +2 and immediate calculation*/
wire [15:0] nxt_addr;
/*instruction to be executed*/
wire [15:0] instr;

wire [3:0] rd, rs, rt;
wire [15:0] reg1, reg2; /*Contents from the Register File*/
wire [15:0] reg_destdata; /*Contents to be written to the Register File*/
wire [15:0] memData; /*Content read from memory*/
wire [15:0] immediate; /*Immediate Calculation for Memory Instructions*/

/*STANDARD*/
wire RegDst;    /*all alu register results*/
wire RegWrite;  /*all alu register results*/
wire ALUSrc;    /*LW or SW*/
wire MemWrite;  /*SW*/
wire MemRead;   /*LW*/
wire MemToReg;  /*LW*/
/************/
/*Custom*/
wire Ben;
wire Breg;
wire Pcs;
wire Llb;
wire Lhb;
wire halt;
assign hlt = halt;
assign pc = curr_addr;

/*updateable_current flags*/
wire [2:0] c_flags; 
/*stored flags*/
wire [2:0] s_flags;
/*enable for flags*/
wire [2:0] e_flags; 

/*ALU*/
wire [15:0] ALUresult;
wire [15:0] ALU_input1;
wire [15:0] ALU_input2;


wire [3:0]desReg; /*changes based on Register or Memory Instructions*/

/*****************************************
 ADDRESS AND INSTRUCTION MANAGEMENT
 *****************************************/


/*pc register to store the current cycle's executed instruction address*/
pc_register pcreg_dut(
    .clk(clk),
    .rst(rst),
    .e(!hlt), //if not halted, get the next instruction for the next pos cycle
    .d(nxt_addr), //input the next address
    .q(curr_addr) 
);


/*instruction register*/
memory1c_instr instrdut(
    .data_out(instr),
    .data_in(),         //no data_in since no writing involved
    .addr(curr_addr),   // byte address, all accesses must be 2-byte aligned; [0] is ignored.
    .enable(1'b1),      //always enable for reading while not on halt
    .wr(rst),          //always disabled for writing
    .clk(clk),
    .rst(rst)
);

pc_control pc_ctrl_dut(
    .c(instr[11:9]), /*condition*/
    .f(s_flags), /*flag reg*/
    .branch(Ben),
    .branchreg(Breg),
    .branchreg_reg1(reg1), /*contents of Rs register for branchreg instructions*/ 
    .opcode_immd(instr[8:0]), /*offset*/
    .curr_addr(curr_addr),
    .nxt_addr(nxt_addr)
);
/*****************************************/


/*****************************************
 FLAGS
 *****************************************/

/*instantiate flag storage dut*/
flagregister reg_flag(
    .clk(clk),
    .rst(rst),
    .d(c_flags),    /* flag modified by ALU continuosly*/
    .e(e_flags),    /* enable signal based on opcode, ALU controls this*/
    .q(s_flags)    /* based on enable modify & store current flags for a cycle*/
);
/*****************************************/


/*****************************************
 REGISTERS MANAGEMENT
 *****************************************/
/* Opcode rd, rs, rt : REGISTER INSTRUCTIONS*/

/* Opcode rt, rs, offset, 101a dddd uuuu uuuu : MEMORY INSTRUCTIONS */

/* Opcode ccci iiii iiii , Opcode cccx ssss xxxx: CONTROL INSTRUCTIONS*/



/*****************************************
 ALU
 *****************************************/

assign immediate = (MemRead | MemWrite) ? {{12{1'b0}},instr[3:0]} << 1: /*LW/SW*/
                    (Llb) ? {{8{1'b0}},instr[7:0]} : /*LLB*/
                    {instr[7:0],{8{1'b0}}}; /*LHB*/
assign ALU_input1 = (MemRead | MemWrite) ? reg1 & 16'hfffe : 
                    (Llb) ? (reg1 & 16'hff00) : /*need only top 2 */
                    (Lhb) ? (reg1 & 16'h00ff) : 
                    reg1;

assign ALU_input2 = ALUSrc ? immediate :  /*shifter also enables the ALUSrc signal to load immediate value*/
                    reg2;

/*****************************************/

assign reg_destdata = MemToReg ? memData : 
                        Pcs ? nxt_addr :
                        ALUresult;

assign rd = instr[11:8];
/*For LLB/LHB we will use rs only such that it maps to the required register address*/
assign rs = (Lhb | Llb) ? rd : instr[7:4]; 
assign rt = (MemWrite | MemRead) ? instr[11:8] : instr[3:0];

assign desReg = RegDst ? rd : rt; /* false for SW case*/

/*Register 16x16*/
RegisterFile rf(
    .clk(clk), 
    .rst(rst), 
    .SrcReg1(rs), /*Reg1 encoded*/ 
    .SrcReg2(rt), /*Reg2 encoded*/
    .DstReg(desReg), /*Destination Reg encoded*/
    .WriteReg(RegWrite), /*Is data supposed to be written to the Register*/
    .DstData(reg_destdata), /* If data is supposed to be written, then what is it*/
    .SrcData1(reg1), /*Contents of Reg1: maps to Rs*/
    .SrcData2(reg2) /*Contents of Reg2: maps to Rt*/
);
/*****************************************/


/*****************************************
 Memory Management
 *****************************************/
memory1c_data memdut(
    .data_out(memData),
    .data_in(reg2),         /*only store word will use this -- Rt content*/
    .addr(ALUresult),     /*byte address, all accesses must be 2-byte aligned; [0] is ignored.*/
    .enable(1'b1),
    .wr(MemWrite),
    .clk(clk),
    .rst(rst)
);
/*****************************************/

/*****************************************
 CPU control
 *****************************************/
 CPU_control cpu_ctrl_dut(
    .opc(instr[15:12]), 
    .halt(halt), 
    .RegDst(RegDst), 
    .ALUSrc(ALUSrc), 
    .MemRead(MemRead), 
    .MemWrite(MemWrite), 
    .MemtoReg(MemToReg), 
    .RegWrite(RegWrite), 
    .Lower(Llb), 
    .Higher(Lhb), 
    .BEn(Ben), 
    .Br(Breg), 
    .PCS(Pcs)
 );
/*****************************************/

/*****************************************
 ALU control
***********e******************************/
alu alu_dut(
    .ALU_Out(ALUresult), 
    .ALU_In1(ALU_input1), 
    .ALU_In2(ALU_input2), 
    .Opcode(instr[15:12]),
    .Flags(c_flags), 
    .en(e_flags)
);
/*****************************************/
endmodule