module ALU_control (
    input  wire [1:0] ALU_op,
    input  wire [6:0] funct7,
    input  wire [2:0] funct3,
    output reg  [3:0] ALU_control
);

always @(*) begin
    // default để tránh latch / X
    ALU_control = 4'b0010; // ADD

    case (ALU_op)
        2'b00: begin
            // Load/Store
            ALU_control = 4'b0010; // ADD
        end

        2'b01: begin
            // Branch
            ALU_control = 4'b0110; // SUB
        end

        2'b10: begin
            // R-type hoặc I-type ALU
            case (funct3)
                3'b000: begin
                    // ADD / SUB (or ADDI if I-type)
                    // R-type: funct7=0000000 -> ADD, funct7=0100000 -> SUB
                    // I-type addi: funct7 = 0000000 (imm[11:5]) -> ADD
                    case (funct7)
                        7'b0000000: ALU_control = 4'b0010; // ADD / ADDI
                        7'b0100000: ALU_control = 4'b0110; // SUB (R-type)
                        default:    ALU_control = 4'b0010; // fallback ADD
                    endcase
                end

                3'b111: begin
                    // AND / ANDI
                    ALU_control = 4'b0000; // AND
                end

                3'b110: begin
                    // OR / ORI
                    ALU_control = 4'b0001; // OR
                end

                default: begin
                    // not support another funct3 (XOR, SLL, SRL/SRA, SLT, SLTU,...)
                    ALU_control = 4'b0010; // fallback ADD
                end
            endcase
        end

        default: begin
            ALU_control = 4'b0010; // fallback ADD
        end
    endcase
end

endmodule