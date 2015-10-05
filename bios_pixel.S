/*
Set pixel at position (1, 1) to a clear red color (0Ch) in 13h video mode.

You have to look a bit hard to see it.

Mode 13h has: 320x200 Graphics, 256 colors, 1 page.

https://en.wikipedia.org/wiki/Mode_13h describes it a bit.

TODO Color encoding: is there any logic?
Shown on wiki page: https://en.wikipedia.org/wiki/Mode_13h
Does not seem to be R  R  R  G  G  G  B  B mentioned at: https://en.wikipedia.org/wiki/8-bit_color
Asked at: http://stackoverflow.com/questions/14233437/convert-normal-256-color-to-mode-13h-version-color

Things get much more involved from protected mode:
http://stackoverflow.com/questions/14419088/how-to-draw-a-pixel-on-the-screen-in-protected-mode-in-x86-assembly
TODO do it!

And for hardware accelaration, you need to make real drivers
(to semi-documented complex GPU hardware :-) )
http://wiki.osdev.org/How_do_I_set_a_graphics_mode
*/

#include "common.h"
BEGIN
    /* Enter video mode 13h: */
    mov $0x0013, %ax
    int $0x10
start:
    /*
    Draw the pixel pixel.

    AH = 0Ch
    AL = Color
    BH = Page Number
    CX = x
    DX = y
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
