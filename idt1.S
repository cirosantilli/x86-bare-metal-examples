/*
# IDT 1

Sanity check that we can also handle int 1 besides just int 0.

Expected output: "int 1 handled"
*/

#include "common.h"

BEGIN
    STAGE2
    CLEAR
    PROTECTED_MODE
    IDT_SETUP_ENTRY $1, $handler
    lidt idt_descriptor
    int $1
    jmp .
IDT_START
IDT_SKIP 1
IDT_ENTRY
IDT_END
handler:
    VGA_PRINT_STRING $message
    iret
message:
    .asciz "int 1 handled"
