/* https://github.com/cirosantilli/x86-bare-metal-examples#pit */

#include "common.h"
BEGIN
    IVT_PIT_SETUP
    /* Operating mode: 0 rate generator. */
    OUTB $0b00110000, PORT_PIT_MODE
    /* TODO: Set the counter to 1. */
    mov $0x01, %al
    out %al, PORT_PIT_CHANNEL0
    mov $0x00, %al
    out %al, PORT_PIT_CHANNEL0
    sti
    jmp .
handler:
    cli
    PUTC $'a
    PIC_EOI
    sti
    iret
