/*
# IDT

# Interrupt Descriptor Table

Expected output: "a"

The first 32 handlers are reserved by the processor and have predefined meanings.

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
    IDT_SETUP_ENTRY $0, $handler
    lidt idt_descriptor
    int $0
    jmp .
IDT_START
IDT_ENTRY
IDT_END
handler:
    /* TODO needed? Molloy uses it. */
    /*cli*/
    VGA_PRINT_STRING $message
    iret
message:
    .asciz "a"
