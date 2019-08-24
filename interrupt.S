/* https://github.com/cirosantilli/x86-bare-metal-examples#interrupts */

#include "common.h"
BEGIN
    CLEAR
    /* Set address of the handler for interrupt 0. */
    movw $handler, 0x00
    /* Set code segment of the handler for interrupt 0. */
    mov %cs, 0x02
    int $0
    PUTC $'b
    hlt
handler:
    PUTC $'a
    iret
