/*
# IDT Zero Divide

Division by zero causes a Divide Error which Intel notes as `#DE`.

Expected output: "a"

It is then handled by IDT 0.

Remember that DE is not *only* for division by zero: it also happens on overflow!
Thus the name: Division Error, and not Division by zero.

- http://stackoverflow.com/questions/33029457/what-to-do-in-interrupt-handler-for-divide-by-zero
*/

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
    /* The iret jumps back here! */
    div %ecx
    jmp .
IDT_START
IDT_ENTRY
IDT_END
handler:
    VGA_PRINT_STRING $message
    /* If we don't do this, we get an infinite loop! */
    mov $1, %ecx
    iret
message:
    .asciz "a"
