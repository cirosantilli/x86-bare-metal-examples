/*
# Protected mode

Major changes:

-   BIOS cannot be used anymore

-   GDT takes effect immediately so we *have* to deal with it now,
    and we will later turn on paging

-   we have to encode instructions differently.
    Note that in 16-bit 32-bit instructions were encodable, but with a prefix.

TODO get working.

- http://wiki.osdev.org/Journey_To_The_Protected_Land
- http://wiki.osdev.org/Protected_Mode
- https://github.com/chrisdew/xv6/blob/master/bootasm.S
- https://thiscouldbebetter.wordpress.com/2011/03/17/entering-protected-mode-from-assembly/ FASM based. Did not word on first try, but looks real clean.
- http://stackoverflow.com/questions/28645439/how-do-i-enter-32-bit-protected-mode-in-nasm-assembly

## GDT

Table in memory that gives properties of segment registers.

Segment registers in protected mode point to entries of that table.

The GDT modifies every memory access of a given segment by adding an offset to it.

GDT is used as soon as we enter protected mode, so that's why we have to deal with it, but the preferred way of managing program memory spaces is paging.

## GDTR

## GDT register

In 32-bit, a 6 byte register that holds:

- 2 byte length of the GDT (TODO in bytes or number of entries?)
- 4 byte address of the GDT in memory

In 64 bit, makes 10 bytes, with the address having 8 bytes

GRUB seems to setup one for you: http://www.jamesmolloy.co.uk/tutorial_html/4.-The%20GDT%20and%20IDT.html
*/

#include "common.h"
BEGIN
cli

    /* Set the GDT register with start address of Global Descriptor Table */
    lgdt gdt
    mov %cr0, %eax
    /* Set PE (Protection Enable) bit in CR0 (Control Register 0) */
    or $1, %al
    mov %eax, %cr0

    /*
    TODO why 8?

    Perform far jump to selector 08h (offset into GDT,
    pointing at a 32bit PM code segment descriptor)
    to load CS with proper PM32 descriptor).
    */
    ljmp $0x08, $PModeMain

    PModeMain:
    /* TODO load DS, ES, FS, GS, SS, ESP. */

    hlt

    gdt:
    .word 0x1234
    .long 0x12345678
