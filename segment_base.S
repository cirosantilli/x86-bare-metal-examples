/*
TODO get working.

Example of the effect on a memory access of changing the segment base address .

Expected output: "x\na\nb".

Without segment manipulation, the output would be "a".
*/

#include "common.h"

BEGIN
    CLEAR
    STAGE2
    PROTECTED_MODE

    /* Sanity check 1: just print the output. */
    VGA_PRINT_STRING $output

    /* Sanity check 2: make a mov without any segment manipulation. */
    mov message, %cl
    mov %cl, output
    VGA_PRINT_STRING $output

    /* Now for the real action. */

    mov $gdt_data, %edx
    /* We are touching the 7th byte of the data entry. */
    add $3, %edx
    mov (%edx), %al

    /* Cache it for later. */
    mov %al, %bl

    /* Set the first bit of the descriptor memory. */
    xor $1, %al
    mov %al, (%edx)

    /*
    We must re-set ds because the segment descriptor is cached
    and this updates it:
    http://wiki.osdev.org/Descriptor_Cache
    */
    mov $DATA_SEG, %ax
    mov %ax, %ds

    /*
    This is the only memory access we will make with
    the modified segment, to minimize the effect on our IO.
    */
    mov message, %cl

    /* Restore the old segment. */
    /* TODO is this needed to take into account the new segmentation? */
    dec %edx
    mov %bl, (%edx)
    mov %ax, %ds

    /*
    TODO this sanity check is not printing "ab",
    so we're not restoring the old state properly.
    HOW??
    */
    VGA_PRINT_STRING $message

    mov %cl, output
    VGA_PRINT_STRING $output

    jmp .

message:
    .asciz "ab"
output:
    .asciz "x"
