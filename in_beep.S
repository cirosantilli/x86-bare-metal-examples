/*
The beep circuit is linked to the PIT.

I think it is possible to make a beep after a certain amount of time passes.

http://fly.srk.fer.hr/GDM/articles/sndmus/speaker1.html
*/

#include "common.h"

.equ div, 1193181 / 1000;

BEGIN
start:
    PUTC($0x61)
    mov $0xb6, %al
    out %al, $0x43    /* Ctr 2, squarewave, load, binary */
    mov div, %al
    out %al, $0x42    /* LSB of counter */
    mov div, %al
    shr $8, %al
    out %al, $0x42    /* MSB of counter */
    in $0x61, %al         /* Dummy read of System Control Port B */
    mov $0x03, %al
    out %al, $0x61    /* Enable timer 2 output to speaker */
    jmp start
END
