/*
This just begs for a non-minimal for-fun infinite loop version.

Do try Ctrl-key combinations.
*/

#include "common.h"
BEGIN
start:
    mov $0x00, %ah
    int $0x16
    PUTC <%al>
    jmp start
