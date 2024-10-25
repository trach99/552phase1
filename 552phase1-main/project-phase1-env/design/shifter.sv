module shifter (
    input [1:0] opcode,
    input [15:0] a,        // rs register (data to shift)
    input [15:0] b,        // rt/immediate register (shift amount in binary)
    output [15:0] result   // rd register
);

    // Temporary shift registers for each shift level
    reg [15:0] sr_0;
    reg [15:0] sr_1;
    reg [15:0] sr_2;
    reg [15:0] sr_3;

    // Define opcodes as parameters
    parameter SLL = 2'b00;
    parameter SRA = 2'b01;
    parameter ROR = 2'b10;

    // Base-3 equivalent of the binary shift amount
    reg [5:0] base3_shift;

    // Conversion from 4-bit binary (b[3:0]) to base-3 representation
    always @(*) begin
        case(b[3:0])
            4'b0000: base3_shift = 6'b000000; // 0 in base-3
            4'b0001: base3_shift = 6'b000001; // 1 in base-3
            4'b0010: base3_shift = 6'b000010; // 2 in base-3
            4'b0011: base3_shift = 6'b000100; // 10 in base-3
            4'b0100: base3_shift = 6'b000101; // 11 in base-3
            4'b0101: base3_shift = 6'b000110; // 12 in base-3
            4'b0110: base3_shift = 6'b001000; // 20 in base-3
            4'b0111: base3_shift = 6'b001001; // 21 in base-3
            4'b1000: base3_shift = 6'b001010; // 22 in base-3
            4'b1001: base3_shift = 6'b010000; // 100 in base-3
            4'b1010: base3_shift = 6'b010001; // 101 in base-3
            4'b1011: base3_shift = 6'b010010; // 102 in base-3
            4'b1100: base3_shift = 6'b010100; // 110 in base-3
            4'b1101: base3_shift = 6'b010101; // 111 in base-3
            4'b1110: base3_shift = 6'b010110; // 112 in base-3
            4'b1111: base3_shift = 6'b011000; // 120 in base-3
            default: base3_shift = 6'b000000; // Default to 0
        endcase
    end

    // Shifting Logic
    always @(*) begin
        case (opcode)
            SLL: begin
                // Shift left logical based on base-3 digits
                sr_0 = (base3_shift[1:0] == 2'd1) ? a << 1 : 
                       (base3_shift[1:0] == 2'd2) ? a << 2 : a;
                       
                sr_1 = (base3_shift[3:2] == 2'd1) ? sr_0 << 3 :
                       (base3_shift[3:2] == 2'd2) ? sr_0 << 6 : sr_0;
                       
                sr_2 = (base3_shift[5:4] == 2'd1) ? sr_1 << 9 :
                       (base3_shift[5:4] == 2'd2) ? sr_1 << 12 : sr_1;
                       
                sr_3 = sr_2;
            end
            SRA: begin
                // Shift right arithmetic based on base-3 digits
                sr_0 = (base3_shift[1:0] == 2'd1) ? {a[15], a[15:1]} : 
                       (base3_shift[1:0] == 2'd2) ? {{2{a[15]}}, a[15:2]} : a;
                       
                sr_1 = (base3_shift[3:2] == 2'd1) ? {{3{sr_0[15]}}, sr_0[15:3]} :
                       (base3_shift[3:2] == 2'd2) ? {{6{sr_0[15]}}, sr_0[15:6]} : sr_0;
                       
                sr_2 = (base3_shift[5:4] == 2'd1) ? {{9{sr_1[15]}}, sr_1[15:9]} :
                       (base3_shift[5:4] == 2'd2) ? {{12{sr_1[15]}}, sr_1[15:12]} : sr_1;
                       
                sr_3 = sr_2;
            end
            ROR: begin
                // Rotate right based on base-3 digits
                sr_0 = (base3_shift[1:0] == 2'd1) ? {a[0], a[15:1]} : 
                       (base3_shift[1:0] == 2'd2) ? {a[1:0], a[15:2]} : a;
                       
                sr_1 = (base3_shift[3:2] == 2'd1) ? {sr_0[2:0], sr_0[15:3]} :
                       (base3_shift[3:2] == 2'd2) ? {sr_0[5:0], sr_0[15:6]} : sr_0;
                       
                sr_2 = (base3_shift[5:4] == 2'd1) ? {sr_1[8:0], sr_1[15:9]} :
                       (base3_shift[5:4] == 2'd2) ? {sr_1[11:0], sr_1[15:12]} : sr_1;
                       
                sr_3 = sr_2;
            end
            default: 
                sr_3 = a; // Default to no shift/rotation
        endcase
    end

    // Final result assignment
    assign result = sr_3;

endmodule