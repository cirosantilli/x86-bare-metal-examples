/* https://github.com/cirosantilli/x86-bare-metal-examples#real-mode-segmentation */

#include "common.h"
BEGIN
    CLEAR

    /* It is not possible to encode moving immediates
     * to segment registers: we must either:
     *
     * * pass through a general register ax
     * * pop from the stack
     */
    mov $1, %ax
    mov %ax, %ds
    mov %ds:msg, %al
    PUTC <%al>

    /* %ds is the default segment for GAS memory operations
     * if we don't write it explicitly.
     */
    mov msg, %al
    PUTC <%al>

    mov $1, %ax
    mov %ax, %es
    mov %es:msg, %al
    PUTC <%al>

    mov $1, %ax
    mov %ax, %fs
    mov %fs:msg, %al
    PUTC <%al>

    mov $1, %ax
    mov %ax, %gs
    mov %gs:msg, %al
    PUTC <%al>

    mov $1, %ax
    mov %ax, %ss
    mov %ss:msg, %al
    PUTC <%al>

    hlt
msg:
    /* Push the correct A forward 16 bytes in memory
     * to compensate for the segments.
     */
    .fill 0x10
    .byte 'A'
