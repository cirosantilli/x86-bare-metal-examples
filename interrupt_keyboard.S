/*
TODO get working. Vs `in_keyboard`?
*/

#include "common.h"
BEGIN
    CLEAR
    /*
    I've read that the keyboard handler is the number 1 (second one),
    and each entry is 4 byte wide.
    */
    movw $handler, 0x04
    movw $0x00, 0x06
    sti
loop:
    jmp loop
handler:
    PUTC($0x61)
    iret
jmp loop
