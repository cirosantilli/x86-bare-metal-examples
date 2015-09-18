/*
Clear screen by scrolling.
*/

#include "common.h"
BEGIN

/*
Print one char to ensure that something will be claered.

On some systems, BIOS messages get automatically cleared. Not the case for QEMU 2.0.0.
*/
mov $0x0E40, %ax
int $0x10

/* Function ID. */
mov $0x06, %ah
/* nr. of lines to scroll, 00 means clear window. */
mov $0x0, %al
/* TODO: I think this is the style. */
mov $0x7, %bh
/* CH,CL: row,column upper left corner (00:00) */
mov $0x0, %cx
/* DH,DL: row,column lower right corner (24:79) */
mov $0x184f, %dx
int $0x10

hlt
END
