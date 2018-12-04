/* https://github.com/cirosantilli/x86-bare-metal-examples#interrupts */

#include "common.h"
BEGIN
    CLEAR
    /* Set address of the handler for interrupt 1. */
    movw $handler, 0x04
    /* Set code segment of the handler for interrupt 1. */
    mov %cs, 0x06
    int $1
    PUTC $'b
    hlt
handler:
    PUTC $'a
    iret
