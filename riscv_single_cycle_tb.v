`timescale 1ns/1ps

module riscv_single_cycle_tb;

    reg clk;
    reg rst_n;

    riscv_top dut (
        .clk  (clk),
        .rst_n(rst_n)
    );

    // Clock 10ns
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_riscv_top);
    end

    initial begin
        rst_n = 1'b0;

        // clear instruction memory
        dut.u_imem.Imem[0] = 32'b0;
        dut.u_imem.Imem[1] = 32'b0;
        dut.u_imem.Imem[2] = 32'b0;
        dut.u_imem.Imem[3] = 32'b0;
        dut.u_imem.Imem[4] = 32'b0;
        dut.u_imem.Imem[5] = 32'b0;
        dut.u_imem.Imem[6] = 32'b0;
        dut.u_imem.Imem[7] = 32'b0;

        // addi x1, x0, 5
        dut.u_imem.Imem[0] = 32'h00500093;

        // addi x2, x0, 7
        dut.u_imem.Imem[1] = 32'h00700113;

        // add x3, x1, x2
        dut.u_imem.Imem[2] = 32'h002081B3;

        // sw x3, 0(x0)
        dut.u_imem.Imem[3] = 32'h00302023;

        // lw x4, 0(x0)
        dut.u_imem.Imem[4] = 32'h00002203;

        // beq x3, x4, +8
        dut.u_imem.Imem[5] = 32'h00418463;

        // addi x5, x0, 99
        dut.u_imem.Imem[6] = 32'h06300293;

        // addi x6, x0, 42
        dut.u_imem.Imem[7] = 32'h02A00313;

        #12;
        rst_n = 1'b1;

        #200;

        $display("========== FINAL RESULT ==========");
        $display("x1 = %0d", dut.u_regfile.Registers[1]);
        $display("x2 = %0d", dut.u_regfile.Registers[2]);
        $display("x3 = %0d", dut.u_regfile.Registers[3]);
        $display("x4 = %0d", dut.u_regfile.Registers[4]);
        $display("x5 = %0d", dut.u_regfile.Registers[5]);
        $display("x6 = %0d", dut.u_regfile.Registers[6]);
        $display("mem[0] = %0d", dut.u_dmem.Dmem[0]);
        $display("pc = 0x%08h", dut.u_pc.PC_out);

        if (dut.u_regfile.Registers[1] != 32'd5)
            $display("FAIL: x1 wrong");
        if (dut.u_regfile.Registers[2] != 32'd7)
            $display("FAIL: x2 wrong");
        if (dut.u_regfile.Registers[3] != 32'd12)
            $display("FAIL: x3 wrong");
        if (dut.u_dmem.Dmem[0] != 32'd12)
            $display("FAIL: mem[0] wrong");
        if (dut.u_regfile.Registers[4] != 32'd12)
            $display("FAIL: x4 wrong");
        if (dut.u_regfile.Registers[5] != 32'd0)
            $display("FAIL: x5 should be skipped by beq");
        if (dut.u_regfile.Registers[6] != 32'd42)
            $display("FAIL: x6 wrong");

        $display("==================================");
        $finish;
    end

    initial begin
        $monitor("t=%0t pc=%h instr=%h x1=%0d x2=%0d x3=%0d x4=%0d x5=%0d x6=%0d",
                 $time,
                 dut.u_pc.PC_out,
                 dut.u_imem.instruction_out,
                 dut.u_regfile.Registers[1],
                 dut.u_regfile.Registers[2],
                 dut.u_regfile.Registers[3],
                 dut.u_regfile.Registers[4],
                 dut.u_regfile.Registers[5],
                 dut.u_regfile.Registers[6]);
    end

endmodule