/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-draw-pixel */

#include "common.h"
BEGIN
    /* Enter video mode 13h. */
    mov $0x0013, %ax
    int $0x10
start:
    /* Draw the pixel:
     *
     * * AH = 0Ch
     * * AL = Color
     * * BH = Page Number
     * * CX = x
     * * DX = y
     */
    mov $0x0C0C, %ax
    mov $0x01, %bh
    mov $0x0001, %cx
    mov $0x0001, %dx
    int $0x10

    inc %cx
    inc %dx
    cmp $201, %dx
    jz end
    jmp start
end:
    hlt
