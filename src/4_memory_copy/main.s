.global _start

_start:
        @ Load src and dst adresses from memory to r4 and r5 registers
        ldr     r3, =src
        ldr     r4, =dst

        @ Copy src to dst using double words operations
        ldrd    r6, r7, [r3]
        strd    r6, r7, [r4]

        @ Write src and dst strings to standard output
        @ A single sys call works because src and dst are contiguous in memory 
        @ but not sure if that is guaranteed
        mov     r7, #4
        mov     r0, #1
        mov     r1, r3
        mov     r2, #16             @ Length of src + dst
        svc     0

        @ Exit program with code 0
        mov     r7, #1
        mov     r0, #0
        svc     0

.data
src:    .string     "Turtle\n"
dst:    .fill       8, 1, 0         @ Reserves 8 1-byte spaces, initialized to 0
