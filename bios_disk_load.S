/*
Load one more sector from the disk
besides the first 512 bytes and do something with it..

Expected outcome: `@` gets printed to the screen.

TODO: not working on:

- Bochs: `BOUND_GdMa: fails bounds test`.
- GRUB `chainloader` through big.img

Does work on QEMU and Thinkpad T400.

Bibliography:

- http://wiki.osdev.org/ATA_in_x86_RealMode_%28BIOS%29
- https://en.wikipedia.org/wiki/INT_13H

TODO answer:

- https://thiscouldbebetter.wordpress.com/2011/03/15/creating-a-bootable-program-in-assembly-language/
- http://stackoverflow.com/questions/7716427/loading-2nd-stage-of-bootloader-and-starting-it
- http://stackoverflow.com/questions/2065370/how-to-load-second-stage-boot-loader-from-first-stage
- http://stackoverflow.com/questions/19381434/cannot-read-disk-sectors-in-assembly-language
- http://stackoverflow.com/questions/15497842/read-a-sector-from-hard-drive-with-int-13h
- http://stackoverflow.com/questions/9899577/example-for-int-13-ah-03h-interupt-assembly
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
    /* Drive number. Starts at 0x80, second one is 0x81. TODO why not from 0? */
    mov $0x80, %dl
    /* cylinder number */
    mov $0, %ch
    /* Head number */
    mov $0, %dh
    /* Starting sector number. 2 because 1 was already loaded. */
    mov $2, %cl
    /* Where to load to. Must coincide with our stage2 for the linking to work. */
    mov $stage2, %bx
    int $0x13

    jmp stage2

/*
Our linker script will put this section on the right place in memory:
just after the magic bytes.
*/
.section .stage2
stage2:
    PUTC($0x0E40)
    hlt
    /*
    Fill up the second sector to 512 byte.

    This should be on the linker script as well in decent programs,
    but let's just put it here to keep our other images smaller.
    */
    .org 512
END

