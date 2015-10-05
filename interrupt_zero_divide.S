/*
Same as doing an `int $0`.
*/

#include "common.h"
BEGIN
    CLEAR
    movw $handler, 0x00
    movw %cs, 0x02
    mov $0, %ax
    div %ax
    jmp fail
handler:
    PUTC($0x61)
fail:
    hlt
