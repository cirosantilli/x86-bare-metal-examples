/* https://github.com/cirosantilli/x86-bare-metal-examples#no-bios-hello-world */

#include "common.h"

BEGIN
    mov $0xB800, %di
    mov %di, %es
    xor %di, %di
    lea msg, %si
    /* clear screen from SeaBIOS messages */
    xor  %ax, %ax
    movw $2000, %cx
    repz stosw
    xor  %di, %di
    /* write a string on the screen */
.loop:
    lodsb
    test %al, %al
    jz .halt
    /* write the character */
    movb %al, %es:(%di)
    /* write color attribute of this character
     * 20d = 0x14 = 10100b = color attributes (red on blue)
     * background color = 1b    = blue
     * foreground color = 100b  = red
     */
    movb $20, %es:1(%di)
    add $0x2, %di
    jmp .loop
.halt:
    hlt
msg:
    .asciz "hello world"
