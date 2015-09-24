/*
Same as doing an `int $0`.
*/

#include "common.h"
BEGIN
    CLEAR
    movw $handler, 0x00
    movw $0x00, 0x02
    mov $0x00, %ax
    div %ax
    jmp fail
handler:
    PUTC($0x61)
fail:
    hlt
END
