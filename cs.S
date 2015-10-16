/*
# CS segment register

# ljmp

Expected outcome: "0102" get printed. Those are the 2 that CS takes in this example.

Explanation: http://stackoverflow.com/a/33177253/895245

TODO is ljmp encodable except with a constant:

- http://stackoverflow.com/questions/1685654/ljmp-syntax-in-gcc-inline-assembly
*/

#include "common.h"
BEGIN
    CLEAR

    ljmp $1, $1f
    1:
    .skip 0x10
    mov %cs, %ax
    PRINT_HEX(%al)

    ljmp $2, $1f
    1:
    .skip 0x20
    mov %cs, %ax
    PRINT_HEX(%al)

    hlt
