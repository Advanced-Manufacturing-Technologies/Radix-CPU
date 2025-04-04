module mem_stage (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] alu_result,
    input  logic [31:0] rs2_val,         // Used for stores
    input  logic [4:0]  rd_idx,
    input  logic [3:0]  instr_type,
    input  logic [31:0] instr,

    output logic [31:0] mem_data_out,    // For loads
    output logic [31:0] writeback_val,   // Result to write to reg
    output logic        reg_we_out       // Whether WB stage should write
);

    // Simple 256 x 32-bit word data memory
    logic [31:0] data_mem [0:255];

    logic [31:0] lw_data;

    // Handle memory read/write
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            lw_data <= 32'b0;
        end else begin
            case (instr_type)
                4'd2: begin // S-Type (Store)
                    if (instr[14:12] == 3'b010) begin // SW
                        data_mem[alu_result[9:2]] <= rs2_val;
                        $display("[MEM] SW MEM[0x%h] <= x%0d = 0x%h", alu_result, rd_idx, rs2_val);
                    end
                end
                4'd1: begin // I-Type (could be load)
                    if (instr[6:0] == 7'b0000011) begin // LW
                        lw_data <= data_mem[alu_result[9:2]];
                        $display("[MEM] LW x%0d <= MEM[0x%h] = 0x%h", rd_idx, alu_result, data_mem[alu_result[9:2]]);
                    end
                end
            endcase
        end
    end

    // Writeback control logic
    always_comb begin
        reg_we_out     = 1'b0;
        writeback_val  = alu_result; // default: ALU result
        mem_data_out   = 32'b0;

        case (instr_type)
            4'd1: begin // I-type
                if (instr[6:0] == 7'b0000011) begin // LW
                    writeback_val = lw_data;
                    mem_data_out  = lw_data;
                end
                reg_we_out = 1'b1;
            end
            4'd0: begin // R-type
                writeback_val = alu_result;
                reg_we_out = 1'b1;
            end
            4'd2: begin // S-type
                reg_we_out = 1'b0;
            end
            default: begin
                reg_we_out = 1'b0;
            end
        endcase
    end

endmodule