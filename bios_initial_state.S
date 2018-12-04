/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-initial-state */

#include "common.h"

.macro INITIAL_STORE x
    mov %\()\x, \x
.endm

.macro INITIAL_DATA x
    \x: .skip 2
    \x\()s: .ascii "\x = \0"
.endm

.macro INITIAL_PRINT x
    PRINT_STRING $\x\()s
    PRINT_BYTES $\x, $2
    PRINT_NEWLINE
.endm

/* Indispensable initialization.
 * This initialization is a bit redundant with BEGIN,
 * and does dirty some registers, but I haven't found a better option.
 */
.code16
    cli
    xor %ax, %ax
    mov %ax, %ds

    /* We want our data do be before STAGE2,
     * or it will get overwritten during the load.
     */
    jmp after_data

    .irp reg, ax, bx, cx, dx, cs, ds, es, fs, gs, ss
        INITIAL_DATA \reg
    .endr
    cr0: .long 0
    cr0s: .ascii "cr0 = \0"

after_data:

    .irp reg, ax, bx, cx, dx, cs, ds, es, fs, gs, ss
        INITIAL_STORE \reg
    .endr

    /* Does not have a 16-bit mov version. */
    mov %cr0, %eax
    mov %eax, cr0

/* We delay a full BEGIN as late as possible
 * to mess with less initial state.
 */
BEGIN

STAGE2

    .irp reg, ax, bx, cx, dx, cs, ds, es, fs, gs, ss
        INITIAL_PRINT \reg
    .endr
    PRINT_STRING $cr0s
    PRINT_BYTES cr0, $4
    PRINT_NEWLINE

    hlt
