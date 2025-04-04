module tb_alu;
    logic [31:0] a, b, r;
    logic [3:0] ctrl;
    logic zero;

    alu uut (
        .op_a(a),
        .op_b(b),
        .alu_ctrl(ctrl),
        .result(r),
        .zero(zero)
    );

    initial begin
        a = 32'd10; b = 32'd5;
        ctrl = 4'b0000; #1 $display("ADD: %0d", r);

        ctrl = 4'b0001; #1 $display("SUB: %0d", r);

        ctrl = 4'b0011; #1 $display("SLT: %0d", r);

        $finish;
    end
endmodule
