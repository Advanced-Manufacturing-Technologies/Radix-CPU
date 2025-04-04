module mem_wb_rg (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] writeback_val_in,
    input  logic [4:0]  rd_idx_in,
    input  logic        reg_we_in,

    output logic [31:0] writeback_val_out,
    output logic [4:0]  rd_idx_out,
    output logic        reg_we_out
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            writeback_val_out <= 32'b0;
            rd_idx_out        <= 5'b0;
            reg_we_out        <= 1'b0;
        end else begin
            writeback_val_out <= writeback_val_in;
            rd_idx_out        <= rd_idx_in;
            reg_we_out        <= reg_we_in;
        end
    end

endmodule