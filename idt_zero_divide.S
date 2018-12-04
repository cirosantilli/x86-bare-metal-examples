/* https://github.com/cirosantilli/x86-bare-metal-examples#idt-divide-by-zero */

#include "common.h"
BEGIN
    STAGE2
    CLEAR
    PROTECTED_MODE
    IDT_SETUP_ENTRY $0, $handler
    lidt idt_descriptor
    mov $0, %edx
    mov $1, %eax
    mov $0, %ecx
    /* The iret jumps back here. */
    div %ecx
    jmp .
IDT_START
IDT_ENTRY
IDT_END
handler:
    VGA_PRINT_STRING $message
    /* If we don't do this, we get an infinite loop. */
    mov $1, %ecx
    iret
message:
    .asciz "division by zero handled"
