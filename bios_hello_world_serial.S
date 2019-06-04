#include "common.h"
BEGIN
    DBG
   mov $0x00, %ah// Initialize COM port
   mov $0xe3, %al// Initialization value
   mov $0x00, %dx// Port number
   int $0x14
   mov $msg, %si
loop:
    lodsb
    mov $0x01, %ah//Send value 
    or %al, %al
    jz halt
    int $0x14
    jmp loop
halt:
    hlt
msg:
.asciz "hello World!\n"
