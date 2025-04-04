`include "../alu_defs.sv"

module ex_stage (
    input  logic        clk, 
    input  logic        rst,
    input  logic [31:0] rs1_val,
    input  logic [31:0] rs2_val,
    input  logic [4:0]  rd_idx,
    input  logic [31:0] instr,
    input  logic [3:0]  instr_type,

    output logic [31:0] alu_result,
    output logic [31:0] rs2_val_out,
    output logic [4:0]  rd_idx_out,
    output logic [31:0] instr_out,
    output logic [3:0]  instr_type_out
);

    logic [31:0] op_b;
    logic [3:0] alu_ctrl;
    logic [31:0] alu_out;
    logic zero;

    always_comb begin
        // Default pass-throughs
        op_b           = rs2_val;
        alu_ctrl       = 4'b0000;
        rs2_val_out    = rs2_val;
        rd_idx_out     = rd_idx;
        instr_out      = instr;
        instr_type_out = instr_type;

        case (instr_type)
            4'b0001: begin // I-type
                $display("I Type instruction detected");
                op_b = { {20{instr[31]}}, instr[31:20] }; // sign-extended immediate
                rd_idx_out = instr[11:7];

                case (instr[14:12])
                    3'b000: alu_ctrl = ALU_ADD;
                    3'b010: alu_ctrl = ALU_SLT;
                    3'b011: alu_ctrl = ALU_SLTU;
                    3'b100: alu_ctrl = ALU_XOR;
                    3'b110: alu_ctrl = ALU_OR;
                    3'b111: alu_ctrl = ALU_AND;
                    3'b001: alu_ctrl = ALU_SLL;
                    3'b101: alu_ctrl = instr[30] ? ALU_SRA : ALU_SRL;
                    default: alu_ctrl = ALU_ADD;
                endcase

                $display("EX: op_a = 0x%h, op_b = 0x%h, ctrl = %0d", rs1_val, op_b, alu_ctrl);
            end
        endcase

        // Inline ALU logic to avoid weird sim ordering
        case (alu_ctrl)
            ALU_ADD:  alu_out = rs1_val + op_b;
            ALU_SUB:  alu_out = rs1_val - op_b;
            ALU_SLL:  alu_out = rs1_val << op_b[4:0];
            ALU_SLT:  alu_out = ($signed(rs1_val) < $signed(op_b)) ? 32'd1 : 32'd0;
            ALU_SLTU: alu_out = (rs1_val < op_b) ? 32'd1 : 32'd0;
            ALU_XOR:  alu_out = rs1_val ^ op_b;
            ALU_SRL:  alu_out = rs1_val >> op_b[4:0];
            ALU_SRA:  alu_out = $signed(rs1_val) >>> op_b[4:0];
            ALU_OR:   alu_out = rs1_val | op_b;
            ALU_AND:  alu_out = rs1_val & op_b;
            default:  alu_out = 32'b0;
        endcase

        alu_result = alu_out;
    end
endmodule