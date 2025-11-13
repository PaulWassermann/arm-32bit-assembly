.syntax unified
.cpu cortex-m4
.thumb

@ TODO: better documentation

// Found on https://www.mikrocontroller.net/articles/ARM-ASM-Tutorial#Clock_Configuration
// but needs some digging to understand
.word 0x20000400
.word 0x080000ed
.space 0xe4

// Clock related addresses
.equ    RCC_ADDR,       0x40021000
.equ    RCC_AHBENR,     (RCC_ADDR + 0x14)           // AHB peripheral clock
                                                    // enable register
.equ    RCC_GPIOE,      (1 << 21)

// GPIOE port related addresses
// We use GPIOE because it's where the STM32F303VC discovery board LED are
// connected (on pins 8 to 15)
.equ    GPIOE_ADDR,     0x48001000
.equ    GPIOE_MODER,    (GPIOE_ADDR + 0x00)         // Port mode register
.equ    GPIOE_OTYPER,   (GPIOE_ADDR + 0x04)         // Port output type register
.equ    GPIOE_ODR,      (GPIOE_ADDR + 0x14)

// Orange LED pin
.equ    PIN,            10

.global _start
_start:
init:
        ldr     r0, =RCC_AHBENR
        ldr     r1, [r0]
        orr     r1, #RCC_GPIOE
        str     r1, [r0]

        ldr     r0, =GPIOE_MODER
        ldr     r1, [r0]
        bic     r1, #(0b11 << (PIN * 2))
        orr     r1, #(0b01 << (PIN * 2))
        str     r1, [r0]

        ldr     r0, =GPIOE_OTYPER
        ldr     r1, [r0]
        orr     r1, #(0b0 << PIN)
        str     r1, [r0]

blink:
        ldr     r0, =GPIOE_ODR
        ldr     r1, [r0]
        eor     r1, #(1 << PIN)
        str     r1, [r0]

        mov     r2, #0x20000

delay:
        subs    r2, #1
        bne     delay
        b       blink
