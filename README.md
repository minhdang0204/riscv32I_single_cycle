# RISC-V RV32I Single-Cycle Processor

This project implements a basic **RISC-V RV32I single-cycle processor** in **Verilog**.  
The design supports a subset of RV32I instructions and includes a simple testbench for simulation.

## Features

The processor currently supports the following instructions:

- **R-type**
  - `add`
  - `sub`
  - `and`
  - `or`

- **I-type**
  - `addi`
  - `andi`
  - `ori`

- **Memory**
  - `lw`
  - `sw`

- **Branch**
  - `beq`

## Project Structure

```text
riscv32I_single_cycle/
│── riscv_top.v
│── program_counter.v
│── PC_next.v
│── Instruction_Mem.v
│── register_file.v
│── Control_unit.v
│── ALU_control.v
│── ALU.v
│── Imm_Gen.v
│── Data_Mem.v
│── Mux.v
│── tb_riscv_top.v
│── README.md
