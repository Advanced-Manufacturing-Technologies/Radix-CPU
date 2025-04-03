module regfile (
    input  wire         clk,
    input  wire         we,       // Write enable
    input  wire  [4:0]  waddr,    // Write register address
    input  wire [31:0]  wdata,    // Write data
    input  wire  [4:0]  raddr1,   // Read address 1
    input  wire  [4:0]  raddr2,   // Read address 2
    output wire [31:0]  rdata1,   // Read data 1
    output wire [31:0]  rdata2    // Read data 2
);

  reg [31:0] regs[31:0];

  // Write
  always @(posedge clk) begin
    if (we && (waddr != 0)) begin
      regs[waddr] <= wdata;
    end
  end

  // Read (combinational)
  assign rdata1 = (raddr1 == 0) ? 32'b0 : regs[raddr1];
  assign rdata2 = (raddr2 == 0) ? 32'b0 : regs[raddr2];

endmodule