/* https://github.com/cirosantilli/x86-bare-metal-examples#paging */

#include "common.h"

BEGIN
    CLEAR
    STAGE2
    PROTECTED_MODE
    SETUP_PAGING_4M

    /* Setup a test canary value. */
    movl $0x1234, 0x1000

    /* Print the canary to make sure it is really there. */
    VGA_PRINT_HEX_4 0x1000

    /* Make page 0 point to page frame 1(i.e. virtual address 0 points to physical address 4KB)
     * by setting bit 12 of the Page Table Entry structure.
     *
     * At SETUP_PAGING_4M, page_table has been setup to
     * point page frame 0(i.e. page 0 point to page frame 0).
     * Bit 12 is the lowest bit of the "Address of 4KB page frame" field,
     * By setting it, can relocate page 0 point to page frame 1.
     */
    orw $0x1000, page_table

    PAGING_ON

    /* THIS is what we've been working for!!!
     * Even though we mov to 0, the paging circuit reads that as physical address 0x1000,
     * so the canary value 0x1234 should be modified to 0x5678.
     **/
    movl $0x5678, 0

    /* Turn paging back off to prevent it from messing with us.
     * Remember that VGA does memory accesses, so if paging is still on,
     * we must identity map up to it, which we have, so this is not mandatory.
     * */
    PAGING_OFF

    /* Print the (hopefully) modified value 0x5678. */
    VGA_PRINT_HEX_4 0x1000
    jmp .
