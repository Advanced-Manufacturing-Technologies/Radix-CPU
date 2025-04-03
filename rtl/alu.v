module alu (
    input  logic [31:0] op_a,       // Operand A
    input  logic [31:0] op_b,       // Operand B
    input  logic [3:0]  alu_ctrl,   // ALU control signal
    output logic [31:0] result,     // ALU output
    output logic        zero        // Zero flag (used for branches)
);

always_comb begin
    case (alu_ctrl)
        ALU_ADD:  result = op_a + op_b;
        ALU_SUB:  result = op_a - op_b;
        ALU_SLL:  result = op_a << op_b[4:0];
        ALU_SLT:  result = ($signed(op_a) < $signed(op_b)) ? 32'd1 : 32'd0;
        ALU_SLTU: result = (op_a < op_b) ? 32'd1 : 32'd0;
        ALU_XOR:  result = op_a ^ op_b;
        ALU_SRL:  result = op_a >> op_b[4:0];
        ALU_SRA:  result = $signed(op_a) >>> op_b[4:0];
        ALU_OR:   result = op_a | op_b;
        ALU_AND:  result = op_a & op_b;
        default:  result = 32'b0;
    endcase
end

assign zero = (result == 32'b0);

endmodule