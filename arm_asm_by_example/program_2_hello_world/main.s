.global _start

_start:
        mov     r7, #4
        mov     r0, #1
        ldr     r1, =msg
        mov     r2, #15
        svc     0

        mov     r7, #1
        mov     r0, #0
        svc     0

.data
msg:    .string         "Hello, World!\n"
