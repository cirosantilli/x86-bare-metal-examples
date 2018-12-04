/* https://github.com/cirosantilli/x86-bare-metal-examples#idt */

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
