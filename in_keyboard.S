/*
Whenever you press a key up or down,
the keyboard hex scancode is printed to the screen.

Only changes in state are shown.

Scancode tables: TODO: official specs?

- http://flint.cs.yale.edu/cs422/doc/art-of-asm/pdf/APNDXC.PDF
- https://en.wikipedia.org/wiki/Scancode

TODO Where does the 0x60 come from?

- http://wiki.osdev.org/I/O_Ports
- http://stackoverflow.com/questions/14194798/is-there-a-specification-of-x86-i-o-port-assignment

TODO Possible to do this with the interrupt table instead of `in`?

TODO understand http://wiki.osdev.org/PS2_Keyboard
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
    PRINT_HEX(%al)
    PRINT_NEWLINE
    jmp loop
