/* https://github.com/cirosantilli/x86-bare-metal-examples#lidt */

#include "common.h"
BEGIN
    CLEAR
    movw $handler, 4
    mov %cs, 6
    movw $4, 8
    movl $4, 0xA
    lidt 8
    int $0
    PUTC $'b
    hlt
handler:
    PUTC $'a
    iret
