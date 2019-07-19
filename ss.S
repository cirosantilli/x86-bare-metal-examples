/* https://github.com/cirosantilli/x86-bare-metal-examples#ss */

#include "common.h"
BEGIN
    /* Save the good sp for later. */
    mov %sp, %bx

    /* Control group: ss == 0. */
    mov $stack, %sp
    pop %ax
    /* Restore the old stack so that it won't mess with our other functions. */
    mov %bx, %sp
    PRINT_HEX <%al>

    /* Now let's move ss and see if anything happens. */
    mov $1, %ax
    mov %ax, %ss
    mov $stack, %sp
    /* This pop should happen 16 bytes higher than the first one. */
    pop %ax
    mov %bx, %sp
    PRINT_HEX <%al>

    hlt

stack:
    .word 1
    /* 2 bytes from the word above + 14 = 16 */
    .skip 14
    /* This is at stack0 + 16 */
    .word 2
