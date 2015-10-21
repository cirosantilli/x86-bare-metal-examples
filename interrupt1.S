/*
Test an interrupt handler different than 0.

Expected outcome: 'ab' gets printed to the screen.
*/

#include "common.h"
BEGIN
    CLEAR
    movw $handler, 0x04
    mov %cs, 0x06
    int $1
    PUTC $'b
    hlt
handler:
    PUTC $'a
    iret
