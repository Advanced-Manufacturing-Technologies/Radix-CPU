module if_id_reg (
    input logic clk, 
    input logic rst,
    input  logic [31:0] instr_in,
    input  logic [31:0] pc_in,
    output logic [31:0] instr_out,
    output logic [31:0] pc_out
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            instr_out <= 32'b0;
            pc_out    <= 32'b0;
        end else begin
            instr_out <= instr_in;
            pc_out    <= pc_in;
        end
    end
endmodule