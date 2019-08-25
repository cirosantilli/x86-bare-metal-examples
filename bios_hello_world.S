/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-hello-world */

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
    .asciz "hello world"
