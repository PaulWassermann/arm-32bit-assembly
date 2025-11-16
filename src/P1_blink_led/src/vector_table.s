.syntax unified
.cpu cortex-m4
.thumb

/* 
A vector table is simply a list of memory addresses indicating to the processor
where some elements are stored in the program image.

According to section "2.3.4. Vector table" of the Programming Manual, "The
vector table contains the reset value of the stack pointer, and the start
addresses, also called exception vectors, for all exception handlers".
*/
.section    .vector_table, "a"
.word       _StackEnd
.word       _ResetHandler
.space      0xe4
