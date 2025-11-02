.global _start

_start:
        @ Initialize registers to store required characters
        mov     r0, #'O'
        mov     r1, #'t'
        mov     r2, #'e'
        mov     r3, #'r'

        @ Write characters to output string
        ldr     r4, =output
        strb    r0, [r4]
        strb    r1, [r4, #1]
        strb    r1, [r4, #2]
        strb    r2, [r4, #3]
        strb    r3, [r4, #4]

        @ Print the output string to standard output
        mov     r7, #4
        mov     r0, #1
        mov     r1, r4
        mov     r2, #7
        svc     0

        @ Exit the program with code 0
        mov     r7, #1
        mov     r0, #0
        svc     0

.data
output:     .string     "     \n"
