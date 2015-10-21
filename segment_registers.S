/*
# Segment registers

Show how most segment registers work in 16-bit real mode.

Expected outcome: 'A' character gets printed 6 times to screen.

On failure, trash is shows.

I think their goal was to implement process virtualization in the past.

The special semantics of other registers will be covered in other files.

Rationale of the registers:

- extend other registers. For e.g., http://stackoverflow.com/questions/17777146/what-is-the-purpose-of-cs-and-ip-registers-intel-8086
- rudimentary virtual process spaces

## ES

TODO: this does seem to have special properties as used by string instructions.

- BIOS calls: `int 13h` disk read, `int 15` memory detection

## FS

## GS

FS and GS are general purpose: they don't generate or are affected implicitly by instructions.

## Vs protected mode

In protected mode, the segment registers point to entries on the GDT:

- http://reverseengineering.stackexchange.com/questions/2006/how-are-the-segment-registers-fs-gs-cs-ss-ds-es-used-in-linux
- http://wiki.osdev.org/Segmentation

Those entries still contain an analogous offset to the real mode offset,
but also much more data, like segment width and permission.

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
    PUTC <%al>

    /*
    %ds is the default segment for GAS memory operations
    if we don't write it explicitly.
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
    /* We push the correct A forward 16 bytes in memory to compensate for the segments. */
    .fill 0x10
    .byte 'A'
