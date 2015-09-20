/*
# Segment registers real mde

Show how most segment registers work in 16-bit real mode.

Expected outcome: 'A' character gets printed 6 times to screen.

On failure, trash is shows.

I think their goal was to implement process virtualization in the past.

In protected mode, they do very different things:

- http://reverseengineering.stackexchange.com/questions/2006/how-are-the-segment-registers-fs-gs-cs-ss-ds-es-used-in-linux
- http://wiki.osdev.org/Segmentation

FS and GS are general purpose: they don't generate or are affected implicitly by instructions.

The special semantics of other registers will be covered in other files.

## How they work

What they do is simple: the full addressing syntax is:

    %segment:a(b, c, d)

and the final address is calculated at:

    %segment * 16 + a + b * c + d

So if we set a segment to 1, it just adds 16 to addresses.

## Instruction encoding

The command:

    objdump -D -b binary -m i8086 segment_registers_real.img

Shows that non ds encodings are achieved through a prefix, except for `ds`:

    20:   a0 63 7c                mov    0x7c63,%al
    29:   a0 63 7c                mov    0x7c63,%al
    34:   26 a0 63 7c             mov    %es:0x7c63,%al
    40:   64 a0 63 7c             mov    %fs:0x7c63,%al
    4c:   65 a0 63 7c             mov    %gs:0x7c63,%al
    58:   36 a0 63 7c             mov    %ss:0x7c63,%al

This makes `ds` the most efficient one for data access, and thus a good default.
*/

#include "common.h"
BEGIN
    CLEAR
    /*
    It is not possible to encode moving immediates
    to segment registers: we must either:

    - pass through a general register ax
    - pop from the stack
    */
    mov $1, %ax
    mov %ax, %ds
    mov %ds:msg, %al
    PUTC(%al)

    /* %ds is the default segment for GAS if we don't write it. */
    mov msg, %al
    PUTC(%al)

    /* Try using other segment as well. */

    /*
    CS is the exception: if we do this, the program halts. TODO why?

    Some info: http://wiki.osdev.org/Segmentation#Operations_that_affect_segment_registers
    */
    /*
    mov $1, %ax
    mov %ax, %cs
    mov %cs:msg, %al
    PUTC(%al)
    */

    mov $1, %ax
    mov %ax, %es
    mov %es:msg, %al
    PUTC(%al)

    mov $1, %ax
    mov %ax, %fs
    mov %fs:msg, %al
    PUTC(%al)

    mov $1, %ax
    mov %ax, %gs
    mov %gs:msg, %al
    PUTC(%al)

    mov $1, %ax
    mov %ax, %ss
    mov %ss:msg, %al
    PUTC(%al)

    hlt
msg:
    /* We push the correct A forward 16 bytes in memory to compensate for the segments. */
    .fill 0x10
    .byte 'A'
END
