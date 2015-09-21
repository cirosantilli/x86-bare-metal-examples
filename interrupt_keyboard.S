/*
TODO get working
*/

#include "common.h"
BEGIN
    CLEAR
    movw $handler, 0x04
    movw $0x00, 0x06
    sti
loop:
    jmp loop
handler:
    PUTC($0x61)
jmp loop
END
