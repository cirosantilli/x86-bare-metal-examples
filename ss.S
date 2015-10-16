/*
# SS segment register

Expected output: "0102".

I think the major effect of it is that anything that uses
`SP` like `PUSH` and `POP`, will actually use 16 * SS + SP instead.
*/

#include "common.h"
BEGIN
    /* Save the good sp for later. */
    mov %sp, %bx

    /* Control group: ss == 0. */
    mov $stack, %sp
    pop %ax
    /* Restore the old stack so that it won't mess with our othe functions. */
    mov %bx, %sp
    PRINT_HEX(%al)

    /* Now let's move ss and see if anything happens. */
    mov $1, %ax
    mov %ax, %ss
    mov $stack, %sp
    /* This pop should happen 16 bytes higher than the first one. */
    pop %ax
    mov %bx, %sp
    PRINT_HEX(%al)

    hlt

stack:
    .word 1
    /* 2 bytes from the word above + 14 = 16 */
    .skip 14
    /* This is at stack0 + 16 */
    .word 2
