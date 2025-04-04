`timescale 1ns/1ps

module radix_tb;
    logic clk;
    logic rst;

    // Instantiate your CPU
    radix_cpu uut (
        .clk(clk),
        .rst(rst)
    );

    // Generate a simple clock (10 ns period = 100 MHz)
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    always @(posedge clk) begin
    $display("PC: %h, instr: %h", uut.pc, uut.instr);
    end

    initial begin
        $display("Resetting processor...");
        rst = 1;     // Assert reset
        #20;
        rst = 0;     // Release reset

        // Let the CPU run for a few cycles
        #100;

        $finish;
    end
endmodule