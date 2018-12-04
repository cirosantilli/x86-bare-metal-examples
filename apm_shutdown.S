/* https://github.com/cirosantilli/x86-bare-metal-examples#apm */

#include "common.h"

BEGIN

mov $0x5301, %ax
xor %bx, %bx
int $0x15

/* Try to set apm version (to 1.2). */
mov $0x530e, %ax
xor %bx, %bx
mov $0x0102, %cx
int $0x15

/* Turn off the system. */
mov $0x5307, %ax
mov $0x0001, %bx
mov $0x0003, %cx
int $0x15
