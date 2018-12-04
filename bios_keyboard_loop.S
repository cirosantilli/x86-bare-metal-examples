/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-keyboard */

#include "common.h"
BEGIN
start:
    mov $0x00, %ah
    int $0x16
    PUTC <%al>
    jmp start
