module ADDSUB_tb;

    // Inputs
    reg [15:0] a, b;
    reg sub;

    // Outputs
    wire [15:0] sum;
    wire ovfl;

    // Instantiate the ADDSUB module
    ADDSUB uut (
        .a(a),
        .b(b),
        .sub(sub),
        .sum(sum),
        .ovfl(ovfl)
    );

    // Self-checking test logic
    initial begin
        $display("Starting ADDSUB testbench...");

        // Test Case 1: Simple Addition (no overflow)
        a = 16'h0010; b = 16'h0020; sub = 0; #10;
        if (sum !== 16'h0030 || ovfl !== 0) 
            $display("Test 1 Failed: sum = %h, ovfl = %b", sum, ovfl);
        else 
            $display("Test 1 Passed: sum = %h, ovfl = %b", sum, ovfl);

        // Test Case 2: Simple Subtraction (no overflow)
        a = 16'h0020; b = 16'h0010; sub = 1; #10;
        if (sum !== 16'h0010 || ovfl !== 0) 
            $display("Test 2 Failed: sum = %h, ovfl = %b", sum, ovfl);
        else 
            $display("Test 2 Passed: sum = %h, ovfl = %b", sum, ovfl);

        // Test Case 3: Positive Overflow (saturated to 0x7FFF)
        a = 16'h7FFF; b = 16'h0001; sub = 0; #10;
        if (sum !== 16'h7FFF || ovfl !== 1) 
            $display("Test 3 Failed: sum = %h, ovfl = %b", sum, ovfl);
        else 
            $display("Test 3 Passed: sum = %h, ovfl = %b", sum, ovfl);

        // Test Case 4: Negative Overflow (saturated to 0x8000)
        a = 16'h8000; b = 16'hFFFF; sub = 0; #10;
        if (sum !== 16'h8000 || ovfl !== 1) 
            $display("Test 4 Failed: sum = %h, ovfl = %b", sum, ovfl);
        else 
            $display("Test 4 Passed: sum = %h, ovfl = %b", sum, ovfl);

        // Test Case 5: Subtraction with Negative Result (no overflow)
        a = 16'h0001; b = 16'h0002; sub = 1; #10;
        if (sum !== 16'hFFFF || ovfl !== 0) 
            $display("Test 5 Failed: sum = %h, ovfl = %b", sum, ovfl);
        else 
            $display("Test 5 Passed: sum = %h, ovfl = %b", sum, ovfl);

        $display("All tests completed.");
        $finish;
    end
endmodule

