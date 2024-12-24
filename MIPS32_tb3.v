/* Example 3

Compute the factorial of a number N stored in memory location 200. The result will be stored in memory location 198.

The steps:

Initialize register R10 with the memory address 200.

Load the contents of memory location 200 into register R3.

Initialize register R2 with the value 1.

In a loop, multiply R2 and R3, and store the product in R2.

Decrement R3 by 1; if not zero repeat the loop.

Store the result (from R3) in memory location 198  */


module test_mips32;

  reg clk1, clk2;
  integer k;
 
  pipe_MIPS32 mips (clk1, clk2);
  
  initial
    begin
      clk1 = 0; clk2 = 0;
      repeat (50)         // Generating two-phase clock
        begin
          #5 clk1 = 1; #5 clk1 = 0;
          #5 clk2 = 1; #5 clk2 = 0;
        end
    end

initial
  begin
    for (k=0; k<31; k++)
      mips.Reg[k] = k;

    mips.Mem[0] = 32'h280a00c8; // ADDI R10, RO,200
    mips.Mem[1] = 32'h28020001; // ADDI R2, R0,1
    mips.Mem[2] = 32'h0e94a000; // OR R20, R20, R20 -- dummy instr.
    mips.Mem[3] = 32'h21430000; // LW R3,0 (R10)     
    mips.Mem[4] = 32'h0e94a000; // OR R20, R20, R20 -- dummy instr.
    mips.Mem[5] = 32'h14431000; // Loop: MUL R2, R2, R3
    mips.Mem[6] = 32'h2c630001; // SUBI  R3,R3,1
    mips.Mem[7] = 32'h0e94a000; // OR R20, R20, R20 -- dummy instr.
    mips.Mem[8] = 32'h3460fffc; // BNEQZ R3, Loop (i.e. -4 offset)
    mips.Mem[9] = 32'h2542fffe;  // SW R2,-2 (R10)
    mips.Mem[10] = 32'hfc000000; // HLT

    mips.Mem[200] = 7;     // Find factorial of 7

    mips.PC = 0;
    mips.HALTED = 0;
    mips.TAKEN_BRANCH = 0;


    #2000 $display ("Mem[200] = %2d, Mem[198] = %6d", mips.Mem[200], mips.Mem[198]);
  end

 initial
   begin
     $dumpfile ("mips.vcd");
     $dumpvars (0, test_mips32);
     $monitor ("R2: %4d", mips.Reg[2]);
     #3000 $finish;
   end
endmodule

/* OUTPUT

R2:    2
R2:    1
R2:    7
R2:   42
R2:  210
R2:  840
R2: 2520
R2: 5040
R2: 5040
Mem[200] =  7, Mem[198] =   5040    */
