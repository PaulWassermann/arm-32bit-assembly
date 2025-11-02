// Macro that writes a null-terminated string to standard output
//
//      Uses :
//      - r0 to load the adress of the string
//      - r1 to store the current character
//      - r2 to store the length of the string
//      - r3 to count the number of characters in the string

.macro  print   str

        ldr     r0, =\str
        mov     r3, #1

1:
        ldrb    r1, [r0, r3]
        cmp     r1, #0
        beq     2f
        add     r3, #1
        b       1b


2:
        mov     r7, #4
        mov     r0, #1
        ldr     r1, =\str
        mov     r2, r3
        svc     0
.endm
