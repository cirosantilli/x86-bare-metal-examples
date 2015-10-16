/*
# Protected mode

Major changes:

-   BIOS cannot be used anymore

-   GDT takes effect immediately so we *have* to deal with it now,
    and we will later turn on paging

-   we have to encode instructions differently.
    Note that in 16-bit 32-bit instructions were encodable, but with a prefix.

## Bibliography

- http://stackoverflow.com/questions/28645439/how-do-i-enter-32-bit-protected-mode-in-nasm-assembly
- http://wiki.osdev.org/Journey_To_The_Protected_Land
- http://wiki.osdev.org/Protected_Mode
- https://github.com/chrisdew/xv6/blob/master/bootasm.S
- https://thiscouldbebetter.wordpress.com/2011/03/17/entering-protected-mode-from-assembly/ FASM based. Did not word on first try, but looks real clean.
- http://skelix.net/skelixos/tutorial02_en.html

## GDT

Table in memory that gives properties of segment registers.

Segment registers in protected mode point to entries of that table.

GDT is used as soon as we enter protected mode, so that's why we have to deal with it, but the preferred way of managing program memory spaces is paging.

### Effect on memory access

The GDT modifies every memory access of a given segment by:

- adding an offset to it
- limiting how big the segment is

If an access is made at an offset larger than allowed: TODO some exception happens, which is like an interrupt, and gets handled by a previously registered handler.

The GDT could be used to implement virtual memory by using one segment per program:

    +-----------+--------+--------------------------+
    | Program 1 | Unused | Program 2                |
    +-----------+--------+--------------------------+
    ^           ^        ^                          ^
    |           |        |                          |
    Start1      End1     Start2                     End2

The problem with that is that each program must have one segment, so if we have too many programs, fragmentation will be very large.

Paging gets around this by allowing discontinuous memory ranges of fixed size for each program.

The format of the GDT is given at: http://wiki.osdev.org/Global_Descriptor_Table

### Effect on permissions

Besides fixing segment sizes, the GDT also specifies permissions to the program that is running:

-   ring level: limits several things that can or not be done, in particular:
    - instructions: e.g. no in / out in ring 3
    - register access: e.g. cannot modify control registers like the GDTR in ring 3. Otherwise user programs could just escape restrictions by changing that!
-   executable, readable and writable bits: which operations can be done

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

    CLEAR

    cli
    /* Tell the processor where our Global Descriptor Table is in memory. */
    lgdt gdt_descriptor

    /* Set PE (Protection Enable) bit in CR0 (Control Register 0) */
    mov %cr0, %eax
    orl $0x1, %eax
    mov %eax, %cr0

    /* TODO why does equ not work? What is the alternative? */
    /*ljmp $CODE_SEG, $b32*/
    /*
    This is needed to set `%cs` to 8.

    8 means the second entry, since each entry is 8 bytes wide,
    and we have an initial null entry.
    */
    ljmp $0x08, $b32

.code32

print32:
    pusha
    # Video memory address.
    mov $0xb8000, %edx
print32.loop:
    mov (%ebx), %al
    # White on black.
    mov $0x0f, %ah
    cmp $0, %al
    je print32.done
    mov %ax, (%edx)
    add $1, %ebx
    add $2, %edx
    jmp print32.loop
print32.done:
    popa
    ret

b32:
    /* Setup the other segments. */
    mov $DATA_SEG, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
    /* TODO: what is the maximum we can put were? Why does `FFFFFFFF` fail? */
    mov $0XFFFFFF00, %ebp
    mov %ebp, %esp

    mov $message, %ebx
    call print32

    jmp .

gdt_start:

gdt_null:
    .long 0x0
    .long 0x0

gdt_code:
    .word 0xffff
    .word 0x0
    .byte 0x0
    .byte 0b10011010
    .byte 0b11001111
    .byte 0x0

gdt_data:
    .word 0xffff
    .word 0x0
    .byte 0x0
    .byte 0b10010010
    .byte 0b11001111
    .byte 0x0

gdt_end:

gdt_descriptor:
   .word gdt_end - gdt_start
   .long gdt_start

.equ CODE_SEG, gdt_code - gdt_start
.equ DATA_SEG, gdt_data - gdt_start

message: .asciz "hello world"
