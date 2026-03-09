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
├── README.md
├── report
├── src/
│   ├── riscv_top.v
│   ├── ALU.v
│   ├── ALU_control.v
│   ├── Control_unit.v
│   ├── Data_Mem.v
│   ├── Imm_Gen.v
│   ├── Instruction_Mem.v
│   ├── Mux.v
│   ├── PC_next.v
│   ├── program_counter.v
│   └── register_file.v
└── tb/
    └── riscv_single_cycle_tb.v
