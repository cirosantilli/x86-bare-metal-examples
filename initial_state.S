/*
Check the initial state the firmware leaves us in.

Could be done with GDB on the emulator, but this will also work on real hardware.
*/

#include "common.h"

.macro INITIAL_STORE x
    mov %\()\x, \x
.endm

.macro INITIAL_DATA x
    \x: .word 0
    \x\()s: .ascii "\x = \0"
.endm

.macro INITIAL_PRINT x
    PRINT $\x\()s
    PRINT_HEX <\x>
    PRINT_NEWLINE
.endm

.irp reg, bx, cx, dx, cs, ds, es, fs, gs, ss
    INITIAL_STORE \reg
.endr

BEGIN

STAGE2

.irp reg, bx, cx, dx, cs, ds, es, fs, gs, ss
    INITIAL_PRINT \reg
.endr

hlt

.irp reg, bx, cx, dx, cs, ds, es, fs, gs, ss
    INITIAL_DATA \reg
.endr
