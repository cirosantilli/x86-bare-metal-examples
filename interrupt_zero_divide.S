/* https://github.com/cirosantilli/x86-bare-metal-examples#interrupts */

#include "common.h"
BEGIN
    CLEAR
    movw $handler, 0x00
    movw %cs, 0x02
    mov $0, %ax
    div %ax
    hlt
handler:
    mov myvar, %ax
    incw myvar
    PRINT_WORD_HEX
    PRINT_NEWLINE
    iret
myvar:
#if 1
    .word 0x0000
#else
    .word 0x0090
#endif
