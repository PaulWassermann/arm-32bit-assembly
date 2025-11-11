.text

.global itoa

/*
Compute base raised to the power of the passed exponent.

        ### Input

        * r0: the base
        * r1: the exponent

        ### Intermediate

        * r2: accumulate the result through successive multiplications

        ### Return

        * r0: base raised to the exponent
*/
pow:
_pow_prologue:
        push    {fp, lr}
        mov     fp, sp

_pow:
        mov     r2, #1

1:
        cmp     r1, #0
        beq     2f
        mul     r2, r0

        sub     r1, #1
        b       1b

2:
        mov     r0, r2

_pow_epilogue:
        mov     sp, fp
        pop     {fp, pc}

/*
// r0 receives the input integer
// r1 receives the input string buffer
*/
itoa:
_itoa_prologue:
        push    {r4, r5, fp, lr}                // We push r4 because it is a
                                                // callee-saved register and
                                                // the itoa subroutine uses it
                                                // for a temp variable
        mov     fp, sp

_itoa:
        cmp     r0, #9
        blt     _itoa_single_digit
        
        mov     r2, #10
        b       _itoa_set_exp

_itoa_single_digit:
        add     r0, #'0'
        strb    r0, [r1], #1
        b       _itoa_epilogue

_itoa_set_exp:
        push    {r0, r1, r2}                    // Push caller-saved registers
                                                // before calling pow subroutine

        mov     r0, #10                         // Prepare inputs for pow
                                                // subroutine
        mov     r1, r2

        bl      pow

        mov     r3, r0                          // Copy result in r3
        pop     {r0, r1, r2}                    // Restore saved registers

        cmp     r0, r3
        bge     _itoa_loop
        sub     r2, #1
        b       _itoa_set_exp

_itoa_loop:
        mov     r4, #0                          // Allocate a temporary variable
                                                // for the digit we search for
        
        push    {r0, r1, r2}
        mov     r0, #10
        mov     r1, r2
        bl      pow
        mov     r3, r0
        pop     {r0, r1, r2}

        mov     r5, r3

_itoa_compare:
        cmp     r0, r5
        blt     _itoa_write
        add     r5, r3
        add     r4, #1
        b       _itoa_compare

_itoa_write:
        add     r4, #'0'
        strb    r4, [r1], #1
        sub     r2, #1
        cmp     r2, #0
        blt     _itoa_epilogue
        sub     r5, r3
        sub     r0, r5
        b       _itoa_loop

_itoa_epilogue:
        mov     sp, fp
        pop     {r4, r5, fp, pc}
