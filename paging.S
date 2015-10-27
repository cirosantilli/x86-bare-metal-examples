/*
# Paging.

Expected output:

    00001234
    00005678

Verbose tutorial: http://www.cirosantilli.com/x86-paging/

TODO: move all this info to the tutorial.

Keep the following Intel shorthands in mind:

- PTE: Page table
- PDE: Page directory
- PDPTE: Page-directory-

## Intel manual

Part 3 has the chapter on Paging.

## Linux kernel

4.2: look under arch/x86/:

- include/asm/pgtable*
- include/asm/page*
- mm/pgtable*
- mm/page*

There seems to be no structs defined to represent the pages, only macros:
`include/asm/page_types.h` is specially interesting. Excerpt:

    #define _PAGE_BIT_PRESENT	0	// is present
    #define _PAGE_BIT_RW		1	// writeable
    #define _PAGE_BIT_USER		2	// userspace addressable
    #define _PAGE_BIT_PWT		3	// page write through

`arch/x86/include/uapi/asm/processor-flags.h` defines CR0

## cr3

The cr3 register does have a format,
it is not simply the address of the page directory:

-   20 top bits: 4KiB address. Since those are the only address bits,
    this implies that the page directory must be aligned to 4Kib.

-   bits 3 and 4: TODO some function I don't understand yet

-   all others: ignored

Many tutorials simply ignore bits 3 and 4, and do a direct address mov to `cr3`.
*/

#include "common.h"

.equ page_directory, __end_align_4k
.equ page_table, __end_align_4k + 0x1000

BEGIN
    CLEAR
    STAGE2
    PROTECTED_MODE

    /*
    Make the first page directory entry point to the page table.
    We must do this at runtime because the first 4 bits are not aligned to bytes.
    */
    mov $page_table, %eax
    /* Zero out the 4 low flag bits of byte 2 (top 20 are address). */
    and $0xF000, %ax
    mov %eax, page_directory
    /* Flags for byte 0. */
    mov $0b00100111, %al
    mov %al, page_directory

    /*
    Make all pages of the first directory into an identity map (linear address == logical address).
    This will give us: 2^10 * 2^12 == 4MiB of identity memory.
    This is particularly important because our code segment is running there.
    */
    mov $0, %eax
    mov $page_table, %ebx
page_setup_start:
    cmp $0x400, %eax
    je page_setup_end

    /*
    Byte 0: fixed flags:
    - 0: present
    - 1: RW
    - 2: user mode can access iff 1
    - 3: Page-level write-through
    - 4: Page-level cache disable
    - 5: accessed
    - 6: dirty
    - 7: PAT: TODO
    */
    movb $0b00100111, (%ebx)

    /*
    Byte 1:
    -   4 bits of flags:
        - 8: Global
        - 9:11: ignored
    -   4 low bits of page address
    */
    mov %eax, %edx
    /*
    4 because the 4 low bits of eax are the 4 high bits of the second byte.
    The 4 low bits of the second byte are flags / ignored and set to 0.
    */
    shl $4, %edx
    mov %dl, 1(%ebx)

    /* Bytes 2 and 3: 16 high bits of page address. */
    mov %eax, %edx
    shr $4, %edx
    mov %dx, 2(%ebx)

    inc %eax
    add $4, %ebx
    jmp page_setup_start
page_setup_end:

    /* Setup a test canary value. */
    mov $0x1234, %eax
    mov %eax, 0x1000

    /* Print the canary to make sure it is really there. */
    VGA_PRINT_HEX 0x1000

    /* Make the page 0 point to page 1. */
    mov page_table, %eax
    or $0x00001000, %eax
    mov %eax, page_table

    /* Tell the CPU where the page directory is. */
    mov $page_directory, %eax
    mov %eax, %cr3

    /* Turn paging on. */
    mov %cr0, %eax
    or $0x80000000, %eax
    mov %eax, %cr0

    /*
    THIS is what we've been working for!!!
    Even though we mov to 0, the paging circuit reads that as physical address 0x1000,
    so the canary value 0x1234 should be modified to 0x5678.
    */
    mov $0x5678, %eax
    mov %eax, 0

    /*
    Turn paging back off to prevent it from messing with us.
    Remember that VGA does memory accesses, so if paging is still on,
    we must identity map up to it, which we have, so this is not mandatory.
    */
    mov %cr0, %eax
    and $0x7FFFFFFF, %eax
    mov  %eax, %cr0

    /* Print the (hopefully) modified value 0x5678. */
    VGA_PRINT_HEX 0x1000
    jmp .

message:
    .asciz "hello world"

/*
.align could use aligned symbols here, but that is less good
as it blows up the size of the image.
The better option is to use the linker script instead.

For this to work, we MUST use STAGE2:
otherwise this align would try to move the location counter to 0x1000,
and then when the linker tries to add the magic boot byte at 510 it blows up with
cannot move location counter backwards.
*/
/*
.align 0x1000
page_directory:
     .byte 0b00100111
     .skip 3

.align 0x1000
page_table:
*/
