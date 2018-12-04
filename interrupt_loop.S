/* https://github.com/cirosantilli/x86-bare-metal-examples#interrupts */

#include "common.h"
BEGIN
    CLEAR
    movw $handler, 0x00
    mov %cs, 0x02
    int $0
handler:
    int $0
