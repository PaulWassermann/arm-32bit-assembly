.include "print.s"

.global _start

_start:
        print   msg

        mov     r7, #1
        mov     r0, #0
        svc     0

.data
msg:    .string     "Hello, World!\n"
