/*
# Paging

Expected output:

    00001234
    00005678

Verbose beginner's tutorial: http://www.cirosantilli.com/x86-paging/

Keep the following Intel shorthands in mind:

- PTE: Page table
- PDE: Page directory
- PDPTE: Page-directory-

## cr3

The cr3 register does have a format, it is not simply the address of the page directory:

-   20 top bits: 4KiB address. Since those are the only address bits,
    this implies that the page directory must be aligned to 4Kib.

-   bits 3 and 4: TODO some function I don't understand yet

-   all others: ignored

Many tutorials simply ignore bits 3 and 4, and do a direct address mov to `cr3`.
*/

#include "common.h"

BEGIN
    CLEAR
    STAGE2
    PROTECTED_MODE
    SETUP_PAGING_4M

    /* Setup a test canary value. */
    mov $0x1234, %eax
    mov %eax, 0x1000

    /* Print the canary to make sure it is really there. */
    VGA_PRINT_HEX_4 0x1000

    /* Make page 0 point to 4KiB. */
    mov page_table, %eax
    or $0x00001000, %eax
    mov %eax, page_table

    PAGING_ON

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
    PAGING_OFF

    /* Print the (hopefully) modified value 0x5678. */
    VGA_PRINT_HEX_4 0x1000
    jmp .
