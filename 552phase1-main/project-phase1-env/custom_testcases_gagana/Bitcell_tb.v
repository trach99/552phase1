module BitCell_TB;

    // Testbench signals
    reg clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2;
    wire Bitline1, Bitline2;

    // Instantiate the BitCell module
    BitCell uut (
        .clk(clk),
        .rst(rst),
        .D(D),
        .WriteEnable(WriteEnable),
        .ReadEnable1(ReadEnable1),
        .ReadEnable2(ReadEnable2),
        .Bitline1(Bitline1),
        .Bitline2(Bitline2)
    );

    // Clock generation (50 MHz)
    always #5 clk = ~clk;

    // Initial block for test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        D = 0;
        WriteEnable = 0;
        ReadEnable1 = 0;
        ReadEnable2 = 0;

        // Apply reset
        #10 rst = 0;

        // Test: Write '1' and read it
        D = 1;
        WriteEnable = 1;
        #10 WriteEnable = 0;  // Disable write
        ReadEnable1 = 1;
        ReadEnable2 = 1;
        #10;

        // Check if Bitline1 and Bitline2 are 1
        $display("Bitline1: %b, Bitline2: %b", Bitline1, Bitline2);

        // Test: Write '0' and read it
        D = 0;
        WriteEnable = 1;
        #10 WriteEnable = 0;
        #10;

        $display("Bitline1: %b, Bitline2: %b", Bitline1, Bitline2);

        // End simulation
       
    end

endmodule

