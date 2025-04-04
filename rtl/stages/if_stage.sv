module if_stage (
    input  logic        clk,
    input  logic        rst,
    output logic [31:0] instr,
    output logic [31:0] pc
);

    logic [31:0] pc_reg;

    // Instruction memory: 256 instructions max (adjust as needed)
    logic [31:0] instr_mem [0:255];

    assign pc = pc_reg;
    assign instr = instr_mem[pc_reg[9:2]]; // word addressable

    // PC update
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            pc_reg <= 32'h00000000;
        else
            pc_reg <= pc_reg + 4;
    end

    // Load memory from file at simulation start
    initial begin
        $display("Loading instruction memory from instr.hex...");
        $readmemh("tests/hex_files/program.hex", instr_mem);
    end

endmodule