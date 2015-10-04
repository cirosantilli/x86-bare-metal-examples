/*
Originally from: https://courses.engr.illinois.edu/ece390/books/labmanual/io-devices-speaker.html

Same as the kernel version.
*/

#include "common.h"
BEGIN
start:
    PUTC($0x61)

    mov $0xb6, %al
    out %al, $0x43

    mov $4560, %ax
    out %al, $0x42

    mov %ah, %al
    out %al, $0x42

    in $0x61, %al

    /* TODO why or, while Linux kernel sets it to 3? */
    or $0b00000011, %al
    out %al, $0x61

    /*
    Pause for duration of note.

    Busy loop of `25 * 2 ^ 16 - 1`
    */
    mov $25, %bx
.pause1:
    mov $65535, %cx
.pause2:
    dec %cx
    jne .pause2
    dec %bx
    jne .pause1

    in $0x61, %al

    /* TODO why Reset bits 1 and 0. */
    and $0b11111100, %al
    out %al, $0x61

    jmp start
END
