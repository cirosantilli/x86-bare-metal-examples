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

BEGIN

INITIAL_STORE(ax)
INITIAL_STORE(bx)
INITIAL_STORE(cx)
INITIAL_STORE(dx)
INITIAL_STORE(cs)

INITIAL_PRINT(ax)
INITIAL_PRINT(bx)
INITIAL_PRINT(cx)
INITIAL_PRINT(dx)
INITIAL_PRINT(cs)

hlt

INITIAL_DATA(ax)
INITIAL_DATA(bx)
INITIAL_DATA(cx)
INITIAL_DATA(dx)
INITIAL_DATA(cs)
