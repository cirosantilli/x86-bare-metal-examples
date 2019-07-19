/* https://github.com/cirosantilli/x86-bare-metal-examples#pit */

#include "common.h"

BEGIN
    IVT_PIT_SETUP
    PIT_GENERATE_FREQUENCY
    PIT_SET_MIN_FREQ
    /* If we comment out sti, nothing happens, because the PIT interrupts are maskable. */
    sti
    jmp .
handler:
    cli
    PUTC $'a
    PUTC $'\n
    /* EOI: it will not fire again unless we reset it. */
    PIC_EOI
    sti
    iret
