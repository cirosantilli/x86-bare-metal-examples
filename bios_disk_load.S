/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-disk-load */

#include "common.h"
BEGIN
    CLEAR

    /* Reset disk. TODO is this really needed?
     * Was suggested in one tutorial.
     */
    /*mov $0, %ah
     *mov $0x80, %dl
     *int $0x13
     */

    /* Read sectors into memory */
    mov $2, %ah
    /* Number of sectors to read. */
    mov $1, %al
    /* Drive number. Starts at 0x80, second one is 0x81. TODO why not from 0?
     *
     * The BIOS stores the right number on dl as an initial state,
     * but we may be destroying it before, and are lazy to properly store it somewhere.
     * http://stackoverflow.com/a/19387093/895245
     */
    mov $0x80, %dl
    /* cylinder number */
    mov $0, %ch
    /* Head number */
    mov $0, %dh
    /* Starting sector number. 2 because 1 was already loaded. */
    mov $2, %cl
    /* Where to load to.
     * Must coincide with our stage2 for the linking to work.
     *
     * The address is calculated as:
     *
     * ....
     * 16 * ES + BX
     * ....
     */
    mov $stage2, %bx
    int $0x13

    jmp stage2

/* Our linker script will put this section on the right place in memory:
 * just after the magic bytes.
 */
.section .stage2
stage2:
    PUTC $'a
    hlt

    /* We could use `.org` here to fill up the second sector to a multiple of 512 bytes.
     * But the linker does that beautifully with `. = ALIGN(512)` for any size of stage2,
     * so we use that instead.
     */
    /*.org 512*/
