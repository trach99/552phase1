module PC_control_tb;

    // Inputs
    reg B;
    reg [2:0] C;
    reg [8:0] I;
    reg [2:0] F;
    reg [15:0] PC_in;

    // Outputs
    wire [15:0] PC_out;

    // Instantiate the PC_control module
    PC_control uut (
        .B(B),
        .C(C),
        .I(I),
        .F(F),
        .PC_in(PC_in),
        .PC_out(PC_out)
    );

    // Initial block for testing
    initial begin
        // Test case 1: Unconditional branch
        B = 1; C = 3'b111; I = 9'b000000001; F = 3'b000; PC_in = 16'h0000; #10;
        $display("PC_out = %h (Expected: taken)", PC_out);

        // Test case 2: Equal condition (Z = 1)
        B = 1; C = 3'b001; I = 9'b000000010; F = 3'b010; PC_in = 16'h0001; #10;
        $display("PC_out = %h (Expected: taken)", PC_out);

        // Test case 3: Not equal condition (Z = 0)
        B = 1; C = 3'b000; I = 9'b000000010; F = 3'b011; PC_in = 16'h0002; #10;
        $display("PC_out = %h (Expected: notTaken)", PC_out);

        // Test case 4: Branch not taken (B = 0)
        B = 0; C = 3'b111; I = 9'b000000001; F = 3'b000; PC_in = 16'h0003; #10;
        $display("PC_out = %h (Expected: notTaken)", PC_out);

        
    end

endmodule

