/*
Check the initial state the firmware leaves us in.

Could be done with GDB on the emulator, but this will also work on real hardware.
*/

#include "common.h"

#define INITIAL_STORE(x) mov % ## x, x

#define INITIAL_DATA(x) \
    x: .word 0;\
    x ## s: .ascii #x " = \0"

#define INITIAL_PRINT(x) \
    PRINT($x ## s);\
    PRINT_HEX(x);\
    PRINT_NEWLINE

INITIAL_STORE(ax)
INITIAL_STORE(bx)
INITIAL_STORE(cx)
INITIAL_STORE(dx)
/*
INITIAL_STORE(cs)
INITIAL_STORE(ds)
INITIAL_STORE(es)
INITIAL_STORE(fs)
INITIAL_STORE(gs)
INITIAL_STORE(ss)
*/

BEGIN

STAGE2

INITIAL_PRINT(ax)
INITIAL_PRINT(bx)
INITIAL_PRINT(cx)
INITIAL_PRINT(dx)
/*
TODO this breaks if I add more code here.
Linked to STAGE2 load I imagine.
*/
/*
INITIAL_PRINT(cs)
INITIAL_PRINT(ds)
INITIAL_PRINT(es)
INITIAL_PRINT(fs)
INITIAL_PRINT(gs)
INITIAL_PRINT(ss)
*/

hlt

INITIAL_DATA(ax)
INITIAL_DATA(bx)
INITIAL_DATA(cx)
INITIAL_DATA(dx)
/*
INITIAL_DATA(cs)
INITIAL_DATA(ds)
INITIAL_DATA(es)
INITIAL_DATA(fs)
INITIAL_DATA(gs)
INITIAL_DATA(ss)
*/
