module id_ex_rg (
    input  logic        clk, 
    input  logic        rst,
    input  logic [31:0] rs1_val,
    input  logic [31:0] rs2_val,
    input  logic [4:0]  rd_idx,
    input  logic [31:0] instr,
    input  logic [3:0]  instr_type,

    output logic [31:0] rs1_val_out,
    output logic [31:0] rs2_val_out,
    output logic [4:0]  rd_idx_out,
    output  logic [31:0] instr_out,
    output  logic [3:0]  instr_type_out
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            rs1_val_out   <= 32'b0;
            rs2_val_out   <= 32'b0;
            rd_idx_out    <= 5'b0;
            instr_type_out  <= 4'b0;
            instr_out       <= 32'b0;
        end else begin
            rs1_val_out   <= rs1_val;
            rs2_val_out   <= rs2_val;
            rd_idx_out    <= rd_idx;
            instr_type_out<= instr_type;
            instr_out     <= instr;
        end
    end
endmodule