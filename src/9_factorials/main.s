/*
When working with procedures / functions, we need ways to:
        
        * pass argument from the caller function to the callee function
        
        * save the return value of the callee for the caller to use
        
        * return from the caller to the callee


ARM standard [1] suggest:
        
        * we use r0 to r3 registers to pass arguments; if those 4 registers are 
        not enough, other arguments should be pushed on the stack.
        
        * we use r0 for the return value

        * r4 to r10 registers are used as variable registers


In the context of function calling, some registers have a special meaning :
        
        * r11 / fp : the frame pointer; points to the the memory address of the
        stack where the stack pointer was when the current function was called.
        It is the base of the current stack frame (useful to reference local
        variables for example)
        
        * r12 / ip : the intra-procedure-call scratch register;; not too sure
        what it is actually used for, I think it has to do with jumping from one
        memory address to another, and it comes especially handy when the 
        destination address is further than about 32 MB. This is because the `b`
        instruction uses 24 bits (3 bytes) to encode the destination address.
        See [2] for further discussion.

        * r13 / sp : the stack pointer; points to the "top" of the stack (
        actually, points to the bottom since it grows towards lower memory
        addresses)

        * r14 / lr : the link register; used by the bl instruction to save the
        current value of the Program Counter register (see below). Is used by 
        the callee function to return to the caller function where it was called

        * r15 / pc : the program counter; points to the current instruction 
        executed


Some registers are call-clobbered / caller-saved and others are call-preserved /
callee-saved ; call-clobbered registers hold arbitrary values after a function
call, when execution returns to the caller whereas call-preserved registers hold
the same values as before the function call:
        
        * call-clobbered: r0, r1, r2, r3, r12 / ip and r14 / lr
        
        * call-preserved: all other registers; r15 / pc is naturally preserved
        in order to resume code execution in the caller function

The distinction between caller-saved and callee-saved registers relies in which
of the callee / caller gets the responsibility of saving the variables.


Important notes :
        
        1)
        When operating the stack, lower registers are pushed to and popped from
        lower memory addresses than higher register; this means that the 
        following instructions are exactly the same:

        push {r0, r1, r2}
        push {r1, r2, r0}

        For these two instructions, r2 will be pushed first, then r1 and finally
        r0. This is useful because we don't have to worry too much about 
        insertion order when popping values:

        push {r0, r2, r1}
        ...                     // Other instructions
        pop  {r2, r1, r0}

        Although registers aren't arranged the same way in the two instructions,
        `pop` will correctly restore each register.

        2)
        The stack must normally be word aligned (32-bit aligned), meaning each 
        push / pop operation should leave the stack pointer at a word boundar; 
        in other words, sp % 4 = 0 must be satisfied at all time.
        However, at a public interface, stack should be double-word aligned,
        meaning sp % 8 = 0 must be satisfied at all time. To follow good 
        practice, I will try to keep the stack 64-bit aligned: for that matter, 
        r12 / ip can be used as a dummy to align the stack when pushing / 
        popping.

N.B. :  A stack frame is all the memory allocated on the stack by a function.

References:

        * [1] https://github.com/ARM-software/abi-aa/blob/main/aapcs32/aapcs32.rst

        * [2] https://keleshev.com/compiling-to-assembly-from-scratch/07-arm-assembly-programming
*/

.text
.include "../commons/print.s"

.equ    fact, 10

.global _start

_start:
        // Not too sure if this actually needed / useful
        push    {fp, lr}
        mov     fp, sp

        mov     r0, #fact
        bl      factorial               // Branch to factorial and save current
                                        // address to Link Register (r14 / lr)

        // After factorial subroutine, r0 contains the result of the operation
        ldr     r1, =result
        bl      itoa

        print   before
        print   result, '\n'

        mov     r7, #1
        mov     r1, #0
        svc     0

/*
Illustration of stack frame :

--------------------------------------------------------------------------------
|   Stack Frame   | Stack address | Stack value |         Description          |
--------------------------------------------------------------------------------
| _start          | 0x0000FFFC    | unknown     | Return pointer               |
|                 | 0x0000FFF8    | unknown     | Stack frame pointer          |
|-----------------|---------------|-------------|------------------------------|
| factorial       | 0x0000FFF4    | _start      | Return pointer               |
|                 | 0x0000FFF0    | 0x0000FFF8  | Stack frame pointer          |
|                 | 0x0000FFEC    | unknown     | Inter-procedure scratch      |
|                 |               |             | register (for alignment)     |
|                 | 0x0000FFE8    | 0x00000009  | Temporary variable           |
|-----------------|---------------|-------------|------------------------------|
| factorial       | 0x0000FFE0    | factorial   | Return pointer               |
|                 | 0x0000FFDC    | 0x0000FFF0  | Stack frame pointer          |
|                 | 0x0000FFD8    | unknown     | Inter-procedure scratch      |
|                 |               |             | register (for alignment)     |
|                 | 0x0000FFD4    | 0x00000008  | Temporary variable           |
|-----------------|---------------|-------------|------------------------------|
| factorial       | ...           | ...         | ...                          |
|                 |               |             |                              |
*/
factorial:
_factorial_prologue:
        push    {fp, lr}                // Build stack frame for factorial 
                                        // function: store link register then 
                                        // frame pointer (since lr is a higher 
                                        // register than fp)

        mov     fp, sp                  // Set frame pointer to address where 
                                        // caller frame pointer resides

_factorial:
        cmp     r0, #1                  // Argument is passed in r0
        beq     _factorial_epilogue

        push    {r0, ip}                // Save temp variable on the stack; use
                                        // ip for alignment

        sub     r0, #1                  // Subtract 1 to input for next 
                                        // factorial call

        bl      factorial

        pop     {r1, ip}                // Restore saved temp variable to 
                                        // perform computation
        mul     r0, r1, r0

_factorial_epilogue:
        mov     sp, fp                  // Clear the stack frame by setting the 
                                        // stack pointer to base pointer of 
                                        // stack frame

        pop     {fp, pc}                // Restore base of caller stack frame 
                                        // and branch to caller by popping lr 
                                        // into pc

.data
before: .string     "Result: "
result: .fill       11, 1, 0
