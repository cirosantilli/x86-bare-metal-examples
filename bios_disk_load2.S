/* Test loading 2 sectors instead of 1. */

#include "common.h"
BEGIN
    CLEAR
STAGE2
    PUTC($0x61)
    jmp sector3
.org 512
sector3:
    PUTC($0x62)
    hlt
