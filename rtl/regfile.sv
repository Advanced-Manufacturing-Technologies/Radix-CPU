module regfile (
    input  wire         clk,
    input  wire         we,       // Write enable
    input  wire  [4:0]  waddr,    // Write register address
    input  wire [31:0]  wdata,    // Write data
    input  wire  [4:0]  rs1,      // Read address 1
    input  wire  [4:0]  rs2,      // Read address 2
    output wire [31:0]  rs1_val,  // Read data 1
    output wire [31:0]  rs2_val   // Read data 2
);

  reg [31:0] regs[31:0];

  // Write
  always @(posedge clk) begin
    if (we && (waddr != 0)) begin
      regs[waddr] <= wdata;
    end
  end

  // Read (combinational)
  assign rs1_val = (rs1 == 0) ? 32'b0 : regs[rs1];
  assign rs2_val = (rs2 == 0) ? 32'b0 : regs[rs2];

endmodule