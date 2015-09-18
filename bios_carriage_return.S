/*
What happens when a newline is output with bios.

Outcome:

    hello
         world

Carriage returns are needed just like in old days.
*/

#include "common.h"
BEGIN
    mov $msg, %si
    mov $0x0e, %ah
loop:
    lodsb
    or %al, %al
    jz halt
    int $0x10
    jmp loop
halt:
    hlt
msg:
    .asciz "hello\n\rworld"
END
