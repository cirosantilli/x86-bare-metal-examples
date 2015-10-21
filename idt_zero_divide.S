/*
# IDT Zero Divide

TODO why does it enter an infinite loop? How to prevent it?

Division by zero causes a Divide Error which Intel notes as `#DE`.
*/

#include "common.h"

BEGIN
    STAGE2
    CLEAR
    PROTECTED_MODE
    lidt idt_descriptor
    mov $0, %eax
    div %eax
    jmp .
/* TODO DRY up with idt.S */
idt_start:
    .word handler
    .word CODE_SEG
    .byte 0
    .byte 0x8E
    .word 0
idt_end:
idt_descriptor:
    .word idt_end - idt_start
    .long idt_start
handler:
    VGA_PRINT_STRING $message
    iret
message:
    .asciz "a"
