#include "common.h"
BEGIN
    /* Initialize COM port. */
    mov $0x00, %ah
    /* Initialization value. */
    mov $0xe3, %al
    /* Port number. */
    mov $0x00, %dx
    int $0x14
    mov $msg, %si
loop:
    lodsb
    /* Send value */
    mov $0x01, %ah
    or %al, %al
    jz halt
    int $0x14
    jmp loop
halt:
    hlt
msg:
    .asciz "hello world\n"
