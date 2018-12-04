/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-sleep */

#include "common.h"
BEGIN
    /* Must enable interrupts, since BIOS uses
     * them to increment the timer.
     */
    sti
    mov $0, %dx
infinite:
    mov $18, %cx
    mov 0x046C, %bx
one_sec:
    mov 0x046C, %ax
    cmp %ax, %bx
    je one_sec
    mov %ax, %bx
    loop one_sec
    PRINT_WORD_HEX <%dx>
    PRINT_NEWLINE
    inc %dx
    jmp infinite
