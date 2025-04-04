`include "../alu_defs.sv";

module id_stage (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] instr,

    output logic [4:0] rs1_idx, rs2_idx, rd_idx,
    output logic [31:0] imm,
    output logic [31:0] ex_pc,
    output logic [6:0] opcode,
    output logic [3:0] instr_type,
    output logic [31:0] instr_out
);

    typedef enum logic [3:0] {
        TYPE_R,
        TYPE_I,
        TYPE_S,
        TYPE_B,
        TYPE_U,
        TYPE_J,
        TYPE_UNKNOWN
    } instr_type_t;

    //instr_type_t instr_type;

    always_comb begin
        // defaults
        rs1_idx   = 5'b0;
        rs2_idx   = 5'b0;
        rd_idx    = 5'b0;
        imm       = 32'b0;
        ex_pc     = 32'b0;

        case (instr[6:0])
            7'b0010011: begin // I-Type ALU instructions
                instr_type = TYPE_I;
                rs1_idx = instr[19:15];
                rd_idx  = instr[11:7];
                opcode = instr[6:0];
            end
            default: begin
                instr_type = TYPE_UNKNOWN;
            end
        endcase
        instr_out = instr;
    end
endmodule