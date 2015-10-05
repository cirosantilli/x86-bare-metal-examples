/*
*/

#include "common.h"
BEGIN
    CLEAR
    movw $handler, 0x00
    mov %cs, 0x02
    int $0
handler:
    PUTC($0x61)
    int $0
