// Macro that writes a null-terminated string to standard output
//
//      Uses :
//      - r0 to store STDOUT file descriptor
//      - r1 to load the adress of the string
//      - r2 to accumulate the number of characters in the string
//      - r3 to store the current character

.macro  print   str:req

        ldr     r1, =\str
        mov     r2, #0

1:
        ldrb    r3, [r1, r2]
        add     r2, #1
        cmp     r3, #0
        beq     2f
        b       1b

2:
        mov     r7, #4
        mov     r0, #1
        // r1 and r2 are already set
        svc     0

.endm
