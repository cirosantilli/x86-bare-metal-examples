/*
Test PRINT_BYTES

Expected output:

    40 41 42 43 44 45 46 47
    48 49 4A 4B 4C 4D 4E 4F
    50
*/

#include "common.h"
BEGIN
    CLEAR
    PRINT_BYTES $s, $17
    hlt
s:
    .ascii "@ABCDEFGHIJKLMNOP"
