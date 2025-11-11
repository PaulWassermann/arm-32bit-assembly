/*
This program takes a positive integer and computes its ASCII representation.

The program handles positive integers up to 10 digits (base ten) using only
addition, subtraction and multiplication.

Use:   
        - r0, r1, r2 (pow macro and system calls)
        - r3, r4, r5, r6, r7, r8 (core functionality)
*/
.include    "../commons/print.s"

.global _start

.equ    num, 1234567

/*
The pow macro takes 3 arguments:
        - base : the number to be exponentiated
        - exp  : the exponent
        - r_out: the register used to store the result

Use:
        - r0 to store base
        - r1 to store exp
        - r2 to accumulate the result through repeated multiplications
        - r_out to store the final result
*/
.macro  pow     base, exp, r_out

        mov     r0, \base
        mov     r1, \exp
        mov     r2, #1

1:
        cmp     r1, #0
        beq     2f
        mul     r2, r0                  // Multiply r0 with r2 and store result
                                        // in r2 (shorthand syntax)
        sub     r1, #1
        b       1b

2:
        mov     \r_out, r2

.endm

/*
Initialize registers and detect special case for zero input.

Branch to: 
        - zero_case if input integer is zero
        - set_exp otherwise.

Use:
        - r3 to store the adress of the preallocated output string
        - r4 to store the input integer
        - r5 to store the exponent
*/
_start:
        ldr     r3, =output
        ldr     r4, =num
        mov     r5, #10

        cmp     r4, #0
        beq     zero_case
        b       set_exp

/*
Code shortcut for input integers equal to zero. Write a single '0' character to
output string.

Branch to:
        - exit

Use:
        - r0 to store the ASCII value of character '0'
        - r3 to read the memory adress of the output string
*/
zero_case:
        mov     r0, #'0'
        strb    r0, [r3], #1
        b       exit

/*
Find the first non-zero digit of the input integer, starting with the most 
significant digit (i.e, we start looking at the 10 to the power of 10 digit).

Branch to :
        - loop if 10 to the power of the current exponent (stored in r5) is 
        greater than the input integer
        - set_exp otherwise
*/
set_exp:
        pow     #10, r5, r7
        cmp     r4, r7
        bge     loop
        sub     r5, #1
        b       set_exp

/*
Outer loop of the program.
*/
loop:
        mov     r6, #0
        pow     #10, r5, r7
        mov     r8, r7

/*
Inner loop of the program.

Branch to:
        - write if we found the value of the input number's digit corresponding
        to the current exponent of ten
        - compare otherwise
*/
compare:
        cmp     r4, r8
        blt     write
        add     r8, r7
        add     r6, #1
        b       compare

/*
Write the digit of the input integer corresponding to the current exponent (r5)
to the output string. Set the register to the adequate values for next loop
iteration.

Branch to:
        - exit if r5  (the exponent) becomes less than zero
        - loop otherwise
*/
write:
        add     r6, #'0'                // Add an offset to r6 so that it comes
                                        // out as the right ASCII character
        strb    r6, [r3], #1
        sub     r5, #1
        cmp     r5, #0
        blt     exit
        sub     r8, r7
        sub     r4, r8
        b       loop


exit:
        print   before
        print   output, '\n'

        mov     r7, #1
        mov     r0, #0
        svc     0

.data
before: .string     "Input number: "
output: .fill       12, 1, 0
