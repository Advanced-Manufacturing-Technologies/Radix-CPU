module radix_cpu (
    input  logic clk,
    input  logic rst
);

    // -----------------------------
    // IF → ID
    logic [31:0] pc, instr;
    logic [31:0] instr_if, pc_if;
    logic [31:0] instr_id, pc_id;

    if_stage u_if (
        .clk(clk),
        .rst(rst),
        .instr(instr_if),
        .pc(pc_if)
    );

    if_id_reg u_if_id (
        .clk(clk),
        .rst(rst),
        .instr_in(instr_if),
        .pc_in(pc_if),
        .instr_out(instr_id),
        .pc_out(pc_id)
    );

    // -----------------------------
    // ID → EX
    logic [31:0] rs1_val, rs2_val, imm, instr_ex, instr_id_out;
    logic [4:0]  rs1_idx, rs2_idx, rd_idx, rd_idx_ex;
    logic [3:0]  alu_ctrl, instr_type, instr_type_ex;

    logic [31:0] rs1_val_ex, rs2_val_ex, writeback_result;
    logic [31:0] alu_result_mem, rs2_val_mem, instr_mem;
    logic [4:0]  rd_idx_mem;
    logic [3:0]  instr_type_mem;
    logic [31:0] alu_result;
    logic        reg_we;
    logic [31:0] mem_data_out;

    // regfile u_regfile (
    //     .clk(clk),
    //     .we(reg_we),
    //     .waddr(rd_idx_mem),                // ✅ writeback target from MEM stage
    //     .wdata(writeback_result),
    //     .rs1(rs1_idx),
    //     .rs2(rs2_idx),
    //     .rs1_val(rs1_val),
    //     .rs2_val(rs2_val)
    // );

    id_stage u_id (
        .clk(clk),
        .rst(rst),
        .instr(instr_id),
        .opcode(),                         // optional
        .rs1_idx(rs1_idx),
        .rs2_idx(rs2_idx),
        .rd_idx(rd_idx),
        .imm(imm),
        .ex_pc(),                          // not used
        .instr_type(instr_type),
        .instr_out(instr_id_out)
    );

    id_ex_rg u_id_ex (
        .clk(clk),
        .rst(rst),
        .rs1_val(rs1_val),
        .rs2_val(rs2_val),
        .rd_idx(rd_idx),
        .instr(instr_id_out),
        .instr_type(instr_type),
        .rs1_val_out(rs1_val_ex),
        .rs2_val_out(rs2_val_ex),
        .rd_idx_out(rd_idx_ex),
        .instr_out(instr_ex),
        .instr_type_out(instr_type_ex)
    );

    ex_stage u_ex (
        .clk(clk),
        .rst(rst),
        .rs1_val(rs1_val_ex),
        .rs2_val(rs2_val_ex),
        .rd_idx(rd_idx_ex),
        .instr(instr_ex),
        .instr_type(instr_type_ex),
        .alu_result(alu_result)
        //.zero() // Optional output
    );

    ex_mem_rg u_ex_mem (
        .clk(clk),
        .rst(rst),
        .alu_result(alu_result),
        .rs2_val(rs2_val_ex),
        .rd_idx(rd_idx_ex),
        .instr(instr_ex),
        .instr_type(instr_type_ex),
        .alu_result_out(alu_result_mem),
        .rs2_val_out(rs2_val_mem),
        .rd_idx_out(rd_idx_mem),
        .instr_out(instr_mem),
        .instr_type_out(instr_type_mem)
    );

    mem_stage u_mem (
        .clk(clk),
        .rst(rst),
        .alu_result(alu_result_mem),
        .rs2_val(rs2_val_mem),
        .rd_idx(rd_idx_mem),
        .instr_type(instr_type_mem),
        .instr(instr_mem),
        .mem_data_out(mem_data_out),
        .writeback_val(writeback_result),
        .reg_we_out(reg_we)
    );

    // WB stage
    logic [31:0] wb_val;
    logic [4:0]  wb_rd;
    logic        wb_we;

    mem_wb_rg u_mem_wb (
        .clk(clk),
        .rst(rst),
        .writeback_val_in(writeback_result),
        .rd_idx_in(rd_idx_mem),
        .reg_we_in(reg_we),
        .writeback_val_out(wb_val),
        .rd_idx_out(wb_rd),
        .reg_we_out(wb_we)
    );

    regfile u_regfile (
        .clk(clk),
        .we(wb_we),           // ✅ now from WB stage
        .waddr(wb_rd),
        .wdata(wb_val),
        .rs1(rs1_idx),
        .rs2(rs2_idx),
        .rs1_val(rs1_val),
        .rs2_val(rs2_val)
    );

endmodule