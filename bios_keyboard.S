/*
http://stackoverflow.com/questions/4113250/how-to-handle-keyboard-in-real-mode-through-bios-interrupts
*/

#include "common.h"
BEGIN
mov $0x00, %ah
int $0x16
PUTC(%al)
hlt
END
