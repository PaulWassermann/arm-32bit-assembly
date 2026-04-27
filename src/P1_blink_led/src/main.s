// Assembler directives 

// Use the unified syntax (between ARM and THUMB instruction sets)
.syntax unified 

// Programming manual (page 1)
.cpu cortex-m4

// Cortex-M4 documentation
.arch armv7-m

// Programming manual, 3.1 "Instruction set summary" (page 50)
.thumb

.include        "src/vector_table.s"

// Reset and Clock Control module
// Reference manual, 3.1.5 "BusMatrix" (page 52) states:
// "Before using a peripheral the user has to enable its clock in the 
// RCC_AHBENR, RCC_APB2ENR or RCC_APB1ENR register"

// Reference manual, 3.2.2 "Memory map and register boundary addresses"
// (page 54)
.equ    RCC_ADDR,       0x40021000
.equ    RCC_AHBENR,     (RCC_ADDR + 0x14)       // Advanced High-performance
                                                // bus peripheral clock enable 
                                                // register
.equ    RCC_GPIOE,      (1 << 21)

// GPIOE port related addresses
// We use GPIOE because it's where the STM32F303VC discovery board LED are
// connected (on pins 8 to 15)
.equ    GPIOE_ADDR,     0x48001000
.equ    GPIOE_MODER,    (GPIOE_ADDR + 0x00)     // Port mode register
.equ    GPIOE_OTYPER,   (GPIOE_ADDR + 0x04)     // Port output type register
.equ    GPIOE_ODR,      (GPIOE_ADDR + 0x14)
.equ    GPIOE_BSRR,     (GPIOE_ADDR + 0x18)     // Port bit set and reset
                                                // register
// Orange LED pin
.equ    PIN,            10

.type   _ResetHandler, %function
.global _ResetHandler
_ResetHandler:

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

        mov     r2, #0x200000

delay:
        subs    r2, #1
        bne     delay
        b       blink
