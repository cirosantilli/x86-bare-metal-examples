/* https://github.com/cirosantilli/x86-bare-metal-examples#lidt */

#include "common.h"
BEGIN
    CLEAR
    movw $handler, 0
    mov %cs, 2
    movw $4, 8
    movl $0, 0xA
    lidt 8
    int $0
    PUTC $'b
    hlt
handler:
    PUTC $'a
    iret
