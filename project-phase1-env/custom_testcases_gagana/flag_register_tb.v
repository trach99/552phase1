module tb_flag_register;

    // Inputs
    reg clk, rst;
    reg [2:0] en;
    reg [2:0] flag_in;

    // Outputs (connected as inout in DUT, but treated as output here)
    wire [2:0] flag_out;

    // Instantiate the flag_register module
    flag_register uut (
        .clk(clk), 
        .rst(rst), 
        .flag_in(flag_in), 
        .flag_out(flag_out), 
        .en(en)
    );

    // Clock generation: 10ns period (5ns high, 5ns low)
    always #5 clk = ~clk;

    // Self-checking test
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;  // Start with reset active
        en = 3'b000;
        flag_in = 3'b000;
        
        // Apply reset and check output
        #10;
        rst = 0;  // Deactivate reset
        if (flag_out !== 3'b000) $display("Test Failed: Reset did not initialize to 0 at time %t", $time);
        else $display("Test Passed: Reset initialized correctly at time %t", $time);

        // Test case 1: Enable only the first flag (ff0)
        flag_in = 3'b101;  // Input flags
        en = 3'b001;       // Enable only ff0
        #10;  // Wait for clock edge

        if (flag_out !== 3'b001) 
            $display("Test Failed: Expected 001, got %b at time %t", flag_out, $time);
        else 
            $display("Test Passed: Correct output 001 at time %t", $time);

        // Test case 2: Enable the second and third flags (ff1, ff2)
        en = 3'b110;  // Enable ff1 and ff2
        #10;  // Wait for clock edge

        if (flag_out !== 3'b101) 
            $display("Test Failed: Expected 101, got %b at time %t", flag_out, $time);
        else 
            $display("Test Passed: Correct output 101 at time %t", $time);

        // Test case 3: No enable (output should remain unchanged)
        flag_in = 3'b111;  // Change input, but en = 0
        en = 3'b000;
        #10;  // Wait for clock edge

        if (flag_out !== 3'b101) 
            $display("Test Failed: Output changed unexpectedly to %b at time %t", flag_out, $time);
        else 
            $display("Test Passed: Output unchanged as expected at time %t", $time);

        // Test case 4: Reset the register and verify
        rst = 1;  // Apply reset
        #10;  // Wait for reset

        if (flag_out !== 3'b000) 
            $display("Test Failed: Reset failed, got %b at time %t", flag_out, $time);
        else 
            $display("Test Passed: Reset successful at time %t", $time);

        $finish;  // End the simulation
    end

endmodule

