module riscv_top (
    input  wire clk,
    input  wire rst_n
);

    //========================
    // PC / Instruction
    //========================
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] instruction;

    //========================
    // Decode fields
    //========================
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;

    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];

    //========================
    // Control signals
    //========================
    wire        branch;
    wire        MemRead;
    wire        MemToReg;
    wire        MemWrite;
    wire        ALUsrc;
    wire        RegWrite;
    wire [1:0]  ALU_op;
    wire [1:0]  ImmSrc;

    //========================
    // Datapath wires
    //========================
    wire [31:0] read_data_1;
    wire [31:0] read_data_2;
    wire [31:0] imm_out;
    wire [3:0]  alu_control_sig;
    wire [31:0] alu_src_b;
    wire [31:0] alu_result;
    wire        zero;
    wire [31:0] mem_read_data;
    wire [31:0] write_back_data;

    //========================
    // Program Counter
    //========================
    program_counter u_pc (
        .clk    (clk),
        .rst_n  (rst_n),
        .PC_in  (pc_next),
        .PC_out (pc_current)
    );

    //========================
    // Instruction Memory
    //========================
    Instruction_Mem u_imem (
        .clk            (clk),
        .rst_n          (rst_n),
        .read_address   (pc_current),
        .instruction_out(instruction)
    );

    //========================
    // Main Control Unit
    //========================
    Control_unit u_ctrl (
        .Opcode   (opcode),
        .branch   (branch),
        .MemRead  (MemRead),
        .MemToReg (MemToReg),
        .MemWrite (MemWrite),
        .ALUsrc   (ALUsrc),
        .RegWrite (RegWrite),
        .ALU_op   (ALU_op),
        .ImmSrc   (ImmSrc)
    );

    //========================
    // Register File
    //========================
    register_file u_regfile (
        .clk             (clk),
        .rst_n           (rst_n),
        .RegWrite        (RegWrite),
        .read_register_1 (rs1),
        .read_register_2 (rs2),
        .write_register  (rd),
        .write_data      (write_back_data),
        .read_data_1     (read_data_1),
        .read_data_2     (read_data_2)
    );

    //========================
    // Immediate Generator
    //========================
    Imm_Gen u_immgen (
        .instr   (instruction),
        .ImmSrc  (ImmSrc),
        .imm_out (imm_out)
    );

    //========================
    // ALU Control
    //========================
    ALU_control u_alu_ctrl (
        .ALU_op      (ALU_op),
        .funct7      (funct7),
        .funct3      (funct3),
        .ALU_control (alu_control_sig)
    );

    //========================
    // ALU source mux
    //========================
    Mux u_alu_src_mux (
        .a   (read_data_2),
        .b   (imm_out),
        .s   (ALUsrc),
        .out (alu_src_b)
    );

    //========================
    // ALU
    //========================
    ALU u_alu (
        .A           (read_data_1),
        .B           (alu_src_b),
        .alu_control (alu_control_sig),
        .alu_result  (alu_result),
        .zero        (zero)
    );

    //========================
    // Data Memory
    //========================
    Data_Mem u_dmem (
        .clk        (clk),
        .rst_n      (rst_n),
        .MemRead    (MemRead),
        .MemWrite   (MemWrite),
        .Address    (alu_result),
        .Write_data (read_data_2),
        .Read_data  (mem_read_data)
    );

    //========================
    // Write-back mux
    //========================
    Mux u_wb_mux (
        .a   (alu_result),
        .b   (mem_read_data),
        .s   (MemToReg),
        .out (write_back_data)
    );

    //========================
    // Next PC logic
    //========================
    PC_next u_pc_next (
        .pc_current (pc_current),
        .imm_ext    (imm_out),
        .branch     (branch),
        .zero       (zero),
        .pc_next    (pc_next)
    );

endmodule