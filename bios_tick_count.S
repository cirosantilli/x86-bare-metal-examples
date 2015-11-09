/*
# BIOS tick count

Method mentioned at: http://stackoverflow.com/a/9973442/895245

TODO Not working on QEMU 2.3.0: the value does not get updated!

But if I run qemu many times in a sequence, it does seem to get incremented...
*/

#include "common.h"
BEGIN
start:
    mov 0x046C, %ax
    #cmp %ax, %bx
    #je start
    PRINT_WORD_HEX
    PRINT_NEWLINE
    #mov %ax, %bx
jmp start
