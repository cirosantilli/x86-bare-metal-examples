/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-draw-pixel */

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
