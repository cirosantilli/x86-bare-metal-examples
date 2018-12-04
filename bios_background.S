/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-color */

#include "common.h"
BEGIN

mov $0x0B, %ah
mov $0x0034, %bx
int $0x10

PUTC $'a

hlt
