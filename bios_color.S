/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-color */

#include "common.h"
BEGIN

/* ID of character to print. */
mov $0x0961, %ax
/* Page, color, */
mov $0x0034, %bx
/* How many times to write.
 * If too big, wraps around screen.
 */
mov $0x0002, %cx
int $0x10

/* The new color is reused only for character that overwrite the writen region.
 *
 * Cursor is not moved by the previous interrupt, so this produces a colored 'a'.
 */
PUTC $'b
PUTC $'c
PUTC $'d

hlt
