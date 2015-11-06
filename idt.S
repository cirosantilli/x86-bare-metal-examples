/*
# IDT

# Interrupt Descriptor Table

Expected output: "int 0 handled"

The first 32 handlers are reserved by the processor and have predefined meanings, as specified in:
https://web.archive.org/web/20151025081259/http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-system-programming-manual-325384.pdf
Table 3-3. "Intel 64 and IA-32 General Exceptions".

## lidt

Analogous to lgdt but for the IDT.

## Linux kernel usage

https://github.com/torvalds/linux/blob/v4.2/arch/x86/entry/entry_64.S
sets them all up: each `idtentry divide_error` call sets up a new one.

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
    VGA_PRINT_STRING $message
    iret
message:
    .asciz "int 0 handled"
