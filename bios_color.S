/*
Write a character N times with given color.

TODO: is this the only way? How to set the current color for ah = 0E?

Color codes: https://en.wikipedia.org/wiki/BIOS_color_attributes
*/

#include "common.h"
BEGIN

/* ID, character to print. */
mov $0x0961, %ax
/* Page, color, */
mov $0x0034, %bx
/*
How many times to write.
If too big, wraps around screen.
*/
mov $0x0001, %cx
int $0x10

/*
The new color is reused only for character that overwrite the writen region.

Cursor is not moved by the previous interrupt, so this produces a colored 'A'.
*/
PUTC($0x62)
PUTC($0x63)

hlt
