/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-disk-load */

#include "common.h"
BEGIN
    CLEAR
STAGE2
    PUTC $'a
    jmp sector3
.org 512
sector3:
    PUTC $'b
    hlt
