/*
# IDT

# Interrupt Descriptor Table

Expected output: "a"

The first 32 handlers are reserved by the processor and have predefined meanings.

0 is division by zero.

TODO on Linux kernel.

## lidt

Analogous to lgdt but for the IDT.

## Bibliography

- http://www.jamesmolloy.co.uk/tutorial_html/4.-The%20GDT%20and%20IDT.html
*/

#include "common.h"

BEGIN
    STAGE2
    CLEAR
    PROTECTED_MODE
    lidt idt_descriptor
    int $0
    jmp .
idt_start:
    /* Low handler address. */
    /* TODO get this proper version working. */
    /*.word (handler & 0x0000FFFF)*/
    .word handler
    /* Segment selector: byte offset into the GDT. */
    .word CODE_SEG
    /* Reserved 0. */
    .byte 0
    /*
    Flags. Format:
    - 1 bit: present. If 0 and this happens, triple fault.
    - 2 bits: ring level we will be called from.
    - 5 bits: fixed to 0xE.
    */
    .byte 0x8E
    /* High word of base. */
    /* TODO get this proper version working. */
    /*.word (handler >> 16) & 0xFFFF*/
    .word 0
idt_end:
/* Exact same structure as gdt_descriptor. */
idt_descriptor:
    .word idt_end - idt_start
    .long idt_start
handler:
    /* TODO needed? Molloy uses it. */
    /*cli*/
    VGA_PRINT_STRING $message
    iret
message:
    .asciz "a"
