/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-scroll */

#include "common.h"
BEGIN

CLEAR
PRINT_STRING $stair

/* Function ID. */
mov $0x06, %ah
/* Number. of lines to scroll */
mov $0x01, %al
/* BIOS color attributes.
 * Background is the clear color.
 * Foreground is set as the new foreground color.
 */
mov $0xA4, %bh
/* CH,CL: row,column upper left corner (00:00)
 * TODO what does that mean?
 */
mov $0x0101, %cx
/* DH,DL: row,column lower right corner (24:79).
 * TODO what does it mean?
 */
mov $0x0202, %dx
int $0x10

hlt
stair:
    .asciz "a\nb\nc\nd"
