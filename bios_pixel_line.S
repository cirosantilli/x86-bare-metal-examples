/*
Draw a 45 degree line of pixels to the screen on 13h video mode.
*/

#include "common.h"
BEGIN
    mov $0x0013, %ax
    int $0x10
    mov $0x0000, %cx
    mov $0x0000, %dx
start:
    mov $0x0C88, %ax
    mov $0x01, %bh
    int $0x10
    inc %cx
    inc %dx
    cmp $201, %dx
    jz end
    jmp start
end:
    hlt
END
