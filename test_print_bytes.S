#include "common.h"
BEGIN
    CLEAR
    PRINT_BYTES $s, $s_len
    hlt
s: .ascii "@ABCDEFGHIJKLMNOP"
.equ s_len, . - s
