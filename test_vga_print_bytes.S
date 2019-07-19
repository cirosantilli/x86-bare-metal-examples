/* https://github.com/cirosantilli/x86-bare-metal-examples#unit-tests */

#include "common.h"
BEGIN
    CLEAR
    PROTECTED_MODE
    /* VGA_BYTES $s, $s_len */
    hlt
s: .ascii "@ABCDEFGHIJKLMNOP"
.equ s_len, . - s
