`timescale 1ns/1ps

module tb_if_stage;

    logic clk = 0;
    logic rst;
    logic [31:0] instr;
    logic [31:0] pc;

    // Instantiate the fetch stage
    if_stage uut (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .pc(pc)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $display("Starting IF stage test...");
        rst = 1;
        #10;
        rst = 0;

        // Let it run for 10 cycles
        repeat (10) begin
            @(posedge clk);
            $display("PC: %h | INSTR: %h", pc, instr);
        end

        $finish;
    end
endmodule