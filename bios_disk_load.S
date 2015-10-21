/*
# Bios disk load

# int 13h

Load one more sector from the disk
besides the first 512 bytes and do something with it.

Expected output: "a"

Grub 2.0 makes several calls to it under `grub-core/boot/i386/pc`

TODO: not working on:

- Bochs: `BOUND_GdMa: fails bounds test`.
- GRUB `chainloader` through big.img

Does work on QEMU and Thinkpad T400.

## int 13

BIOS call used for disk operations.

## Bibliography

- https://en.wikipedia.org/wiki/INT_13H
- http://wiki.osdev.org/ATA_in_x86_RealMode_%28BIOS%29
- https://thiscouldbebetter.wordpress.com/2011/03/15/creating-a-bootable-program-in-assembly-language/
- http://stackoverflow.com/questions/19381434/cannot-read-disk-sectors-in-assembly-language
- http://stackoverflow.com/questions/15497842/read-a-sector-from-hard-drive-with-int-13h
*/

#include "common.h"
BEGIN
    CLEAR

    /*
    Reset disk. TODO is this really needed?
    Was suggested in one tutorial.
    */
    /*
    mov $0, %ah
    mov $0x80, %dl
    int $0x13
    */

    /* Read sectors into memory */
    mov $2, %ah
    /* Number of sectors to read. */
    mov $1, %al
    /*
    Drive number. Starts at 0x80, second one is 0x81. TODO why not from 0?

    The BIOS stores the right number on dl as an initial state,
    but we may be destroying it before, and are lazy to properly store it somewhere.
    http://stackoverflow.com/a/19387093/895245
    */
    mov $0x80, %dl
    /* cylinder number */
    mov $0, %ch
    /* Head number */
    mov $0, %dh
    /* Starting sector number. 2 because 1 was already loaded. */
    mov $2, %cl
    /*
    Where to load to.
    Must coincide with our stage2 for the linking to work.

    The address is calculated as:

        16 * ES + BX
    */
    mov $stage2, %bx
    int $0x13

    jmp stage2

/*
Our linker script will put this section on the right place in memory:
just after the magic bytes.
*/
.section .stage2
stage2:
    PUTC $'a
    hlt

    /*
    We could use `.org` here to fill up the second sector to a multiple of 512 bytes.
    But the linker does that beautifully with `. = ALIGN(512)` for any size of stage2,
    so we use that instead.
    */
    /*.org 512*/
