/*
Whenever you press a key up or down,
the keyboard hex scancode is printed to the screen.

Uses the PS/2 keyboard controller:
http://wiki.osdev.org/%228042%22_PS/2_Controller

Only changes in state are shown.

Scancode tables: TODO: official specs?

- http://flint.cs.yale.edu/cs422/doc/art-of-asm/pdf/APNDXC.PDF
- https://en.wikipedia.org/wiki/Scancode

TODO Possible to do this with the interrupt table instead of `in`?
*/

#include "common.h"
BEGIN
    CLEAR
    /* TODO why CLI makes no difference? We are not using interrupts? */
    /*cli*/
loop:
    /* Store the scancode to al. */
    in $0x60, %al
    cmp %al, %cl
    jz loop
    mov %al, %cl
    PRINT_HEX <%al>
    PRINT_NEWLINE
    jmp loop
