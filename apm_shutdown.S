/*
* http://wiki.osdev.org/Shutdown
* http://stackoverflow.com/questions/21463908/x86-instructions-to-power-off-computer-in-real-mode
* http://stackoverflow.com/questions/678458/shutdown-the-computer-using-assembly
* http://stackoverflow.com/questions/3145569/how-to-power-down-the-computer-from-a-freestanding-environment
*/

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
