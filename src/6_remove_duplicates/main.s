/*
This program deduplicates characters in a string but can more generally
deduplicate bytes in a byte sequence

         Uses:
        - r0 to store the memory adress of the input string
        - r1 to store the memory adress of the output string
        - r2 to store the character read previously
        - r3 to store the current character 
*/

.include    "../commons/print.s"

.global _start

_start:
        ldr     r0, =input
        ldr     r1, =output
        mov     r2, #0              // r2 is initialized to 0 for the first
                                    // iteration of the loop 

loop:
        ldrb    r3, [r0], #1        /* 
                                    During the first iteration of the loop, 
                                    the state of our registers is :
                                    [ 0 ][ S ]tticckkkyy keeyyb...
                                      |    |
                                      r2   r3
                                    */

        cmp     r3, #0              // If the current character is the null 
                                    // byte, it means we reached the end of the
                                    // string
        beq     exit

        cmp     r2, r3              // Compare previous character with current
                                    // one

        mov     r2, r3              // Current character will be the previous 
                                    // character next iteration

        beq     loop                // Immediately loop back if the previous
                                    // and current characters are equal

        strb    r3, [r1], #1        // Reached only if previous and current
                                    // characters are different ; store the
                                    // current character in output string and
                                    // increment r1

        b       loop

exit:
        print   before
        print   input
        print   after
        print   output

        mov     r7, #1
        mov     r0, #0
        svc     0

.data
input:  .string         "Stticckkkyy keeyyboaaarrrdd!!!\n\n"
output: .fill           128, 1, 0   // Since the reserved space for the output
                                    // string is prefilled with zeros, we won't
                                    // need to append a null byte

before: .string         "Before: "
after:  .string          "After: "
