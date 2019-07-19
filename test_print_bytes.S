/* https://github.com/cirosantilli/x86-bare-metal-examples#print_bytes */

#include "common.h"
BEGIN
    CLEAR
    PRINT_BYTES $s, $s_len
    hlt
s: .ascii "@ABCDEFGHIJKLMNOP"
.equ s_len, . - s
