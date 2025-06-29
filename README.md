# MIPS32

MIPS32 Pipeline Processor

Module Overview

This Verilog code implements a 32-bit MIPS (Microprocessor without Interlocked Pipeline Stages) processor with a pipelined architecture. The module takes two clock inputs (`clk1` and `clk2`) and simulates the instruction fetch, decode, execute, memory, and write-back stages of the pipeline. It includes a variety of instructions such as arithmetic, logical, load, store, and branch instructions, along with a halt instruction to stop the processor.

Module Inputs and Outputs
- Inputs:
  - `clk1`, `clk2`: These are the two clock signals used for the two-phase clocking mechanism for the pipeline stages.
  
- Outputs:
  - There are no direct outputs specified, but the module interacts with internal registers and memory to process instructions.

 Internal Registers and Memory
- Registers:
  - `PC`: Program Counter, stores the address of the next instruction to be fetched.
  - `IF_ID_IR`: Instruction register in the IF (Instruction Fetch) stage.
  - `IF_ID_NPC`: Next Program Counter in the IF stage.
  - `ID_EX_IR`, `ID_EX_NPC`: Instruction and Next PC in the ID (Instruction Decode) stage.
  - `ID_EX_A`, `ID_EX_B`: Values of registers `rs` and `rt` in the ID stage.
  - `ID_EX_Imm`: Immediate value used in the ID stage for operations like ADDI, SUBI, etc.
  - `EX_MEM_IR`: Instruction in the EX (Execution) stage.
  - `EX_MEM_ALUOut`: ALU result in the EX stage.
  - `EX_MEM_B`: Value of register `rt` in the EX stage.
  - `EX_MEM_cond`: Condition flag for branch instructions.
  - `MEM_WB_IR`: Instruction in the MEM (Memory) stage.
  - `MEM_WB_ALUOut`: ALU result in the MEM stage.
  - `MEM_WB_LMD`: Load data from memory in the MEM stage.
  - `Reg`: A 32x32 register file to hold the general-purpose registers.
  - `Mem`: A 1024x32 memory block to store data.

- Flags:
  - `HALTED`: A flag to indicate if the processor has halted after encountering a `HLT` instruction.
  - `TAKEN_BRANCH`: A flag to indicate whether a branch instruction was taken.

Instruction Set
The processor supports the following MIPS instructions:
- ADD: Addition of two registers.
- SUB: Subtraction of two registers.
- AND: Bitwise AND of two registers.
- OR: Bitwise OR of two registers.
- SLT: Set on less than.
- MUL: Multiply two registers.
- HLT: Halt the processor.
- LW: Load word from memory.
- SW: Store word to memory.
- ADDI: Add immediate value to register.
- SUBI: Subtract immediate value from register.
- SLTI: Set on less than with immediate value.
- BNEQZ: Branch if not equal to zero.
- BEQZ: Branch if equal to zero.

Pipeline Stages
The module operates in a five-stage pipeline, as follows:

1. IF (Instruction Fetch) Stage (`clk1`):
   - The instruction is fetched from memory (`Mem`) at the address specified by the `PC`.
   - If a branch instruction is encountered (e.g., `BEQZ` or `BNEQZ`), the program counter (`PC`) is updated according to the branch target address.
   - The instruction is stored in `IF_ID_IR`, and the next PC value is stored in `IF_ID_NPC`.

2. ID (Instruction Decode) Stage (`clk2`):
   - The instruction is decoded, and the necessary operands are read from the register file (`Reg`).
   - Immediate values for instructions like `ADDI`, `SUBI`, and `SLTI` are sign-extended and stored in `ID_EX_Imm`.
   - The instruction type (`RR_ALU`, `RM_ALU`, `LOAD`, `STORE`, `BRANCH`, `HALT`) is determined based on the opcode and stored in `ID_EX_type`.

3. EX (Execution) Stage (`clk1`):
   - In this stage, the actual ALU operations are performed (e.g., addition, subtraction, logical operations).
   - For load and store instructions, the effective memory address is computed by adding the base address and the immediate value.
   - For branch instructions, the condition is evaluated, and the branch target is computed.

4. MEM (Memory Access) Stage (`clk2`):
   - If the instruction is a load, the data is fetched from memory (`Mem`) at the address calculated in the previous stage.
   - If the instruction is a store, the data is written to memory at the calculated address.
   - The result of the ALU operation or memory data is passed to the next stage.

5. WB (Write-back) Stage (`clk1`):
   - The results of the ALU operation or memory load are written back to the register file (`Reg`).
   - If a branch is taken, the write-back is disabled to avoid incorrect results.

Key Parameters
- Instruction opcodes (e.g., `ADD`, `SUB`, `LW`, etc.) are defined as 6-bit binary values.
- ALU operation types are defined using 3-bit binary values:
  - `RR_ALU`: Register-Register ALU operations (e.g., `ADD`, `SUB`).
  - `RM_ALU`: Register-Immediate ALU operations (e.g., `ADDI`, `SUBI`).
  - `LOAD`: Load operations (`LW`).
  - `STORE`: Store operations (`SW`).
  - `BRANCH`: Branch operations (`BEQZ`, `BNEQZ`).
  - `HALT`: Halt the processor.

Control Flow and Operations
- The processor handles branches conditionally. If the branch is not taken, the next instruction is fetched sequentially from memory.
- The instruction types are decoded based on the opcode in the instruction (`IF_ID_IR[31:26]`).
- The ALU performs arithmetic and logical operations in the EX stage, while load and store operations interact with memory.

Edge Cases and Assumptions
- The processor assumes the instructions are correctly formatted and that the opcodes are valid.
- The `HLT` instruction halts the processor and prevents any further execution.
- The branch instructions only modify the program counter (`PC`) if the branch condition is met.

Summary
This Verilog module models a pipelined MIPS32 processor that can execute a range of MIPS instructions in five stages: IF, ID, EX, MEM, and WB. It includes mechanisms for handling branches, memory access, and instruction execution. The processor halts when encountering a `HLT` instruction. The design uses a two-phase clocking scheme (`clk1`, `clk2`) for synchronization across pipeline stages.
