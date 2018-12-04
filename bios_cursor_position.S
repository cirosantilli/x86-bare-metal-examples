/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-examples */

#include "common.h"
BEGIN
CLEAR

/* Print "ab" */
PUTC $'a
PUTC $'b

/* Move back to 0, 0.*/
mov $0x02, %ah
/* page number 0. TODO what is this? */
mov $0x0, %bh
/* DH=0 row, DL=0 col */
mov $0x0, %dx
int $0x10

/* Overwrite 'a' with c'. */
PUTC $'c

hlt
