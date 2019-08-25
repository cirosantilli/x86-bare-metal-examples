/* https://github.com/cirosantilli/x86-bare-metal-examples#serial-uart */

#include "common.h"

BEGIN
    /* Initialize the serial. */
    mov $0x00, %ah
    /* Initialization value. */
    mov $0xe3, %al
    /* Port number. */
    mov $0x00, %dx
    int $0x14

    mov $msg, %si
loop:
    lodsb
    mov $0x01, %ah
    or %al, %al
    jz halt
    /* Send value in %al. */
    int $0x14
    jmp loop
halt:
    hlt
msg:
    .asciz "hello world\n"
