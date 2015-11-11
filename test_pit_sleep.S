/*
Expected output: `a\n` gets printed with frequency 2Hz.
*/

#include "common.h"

BEGIN
    IVT_PIT_SETUP
    PIT_GENERATE_FREQUENCY
    PIT_SET_FREQ 1000
    sti
loop:
    PUTC $'a
    PUTC $'\n
    PIT_SLEEP_TICKS $500
    jmp loop
PIT_SLEEP_TICKS_GLOBALS
handler:
    cli
    PIT_SLEEP_TICKS_HANDLER_UPDATE
    PIC_EOI
    sti
    iret
