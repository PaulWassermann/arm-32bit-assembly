/*
This program finds the complement of an ADN sequence and modify said sequence
in-place.

        Uses:
        - r0 to load the memory adress of the ADN sequence
        - r1 to store the current nucleotide base (character) of the sequence
        - r2 to store the complementary nucleotide base of the current one
*/

.include    "../commons/print.s"

.global _start

_start:
        print   before
        print   adn_seq
        print   newline

        ldr     r0, =adn_seq

loop:
        ldrb    r1, [r0]

        cmp     r1, #0
        beq     exit

        cmp     r1, #'A'
        moveq   r2, #'T'

        cmp     r1, #'T'
        moveq   r2, #'A'

        cmp     r1, #'C'
        moveq   r2, #'G'

        cmp     r1, #'G'
        moveq   r2, #'C'

        strb    r2, [r0], #1
        b       loop

exit:
        print   after
        print   adn_seq
        print   newline

        mov     r7, #1
        mov     r0, #0
        svc     0

.data
adn_seq:    .string     "GTACGATGATCACCAGTTACCAAAGCATTACGGAGTGTC"
before:     .string     "Initial sequence: "
after:      .string     "Complemented sequence: "
newline:    .string     "\n"
