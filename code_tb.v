//============================================================
// Testbench for 16-bit Single Port RAM (Asynchronous Read/Write)
//============================================================
// Works perfectly with: single_port_ram_async.v
// Designed for: Cadence Xcelium / SimVision
//============================================================

`timescale 1ns/1ps

module tb_single_port_ram_async;

    // Parameters
    parameter ADDR_WIDTH = 8;
    parameter DATA_WIDTH = 16;

    // Testbench signals
    reg  [ADDR_WIDTH-1:0] addr;
    reg  [DATA_WIDTH-1:0] din;
    reg  we, cs;
    wire [DATA_WIDTH-1:0] dout;

    // Instantiate the DUT
    single_port_ram_async #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .addr(addr),
        .din(din),
        .we(we),
        .cs(cs),
        .dout(dout)
    );

    // Test procedure
    initial begin
        // Initialize
        addr = 8'h00;
        din  = 16'h0000;
        we   = 1'b0;
        cs   = 1'b0;

        // Dump for waveform
        $dumpfile("ram_async.vcd");
        $dumpvars(0, tb_single_port_ram_async);

        // Monitor output in console
        $monitor("Time=%0t ns | CS=%b WE=%b | ADDR=%h | DIN=%h | DOUT=%h", 
                 $time, cs, we, addr, din, dout);

        // ---------------------------------------------
        // Step 1: Write to 3 memory locations
        // ---------------------------------------------
        #10 cs = 1; we = 1;
        addr = 8'h05; din = 16'hAAAA; #10;
        addr = 8'h06; din = 16'h5555; #10;
        addr = 8'h07; din = 16'hF00D; #10;

        // ---------------------------------------------
        // Step 2: Read back (asynchronous)
        // ---------------------------------------------
        we = 0;
        #10 addr = 8'h05; #10;
        addr = 8'h06; #10;
        addr = 8'h07; #10;

        // ---------------------------------------------
        // Step 3: Demonstrate asynchronous nature
        // (Change address while reading)
        // ---------------------------------------------
        #10 addr = 8'h05; #5;
        addr = 8'h06; #5;
        addr = 8'h07; #5;
        addr = 8'h05; #5;

        // ---------------------------------------------
        // Step 4: Disable chip select
        // ---------------------------------------------
        cs = 0;
        #10;

        $display("Simulation completed successfully!");
        $finish;
    end

endmodule
