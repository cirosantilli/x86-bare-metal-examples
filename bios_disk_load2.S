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
