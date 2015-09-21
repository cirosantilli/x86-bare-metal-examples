/*
Minimal interrupt example.

Upon division by zero, the interrupt handler is run,
and it prints the character 'A' to screen.

TODO: is STI not needed because this interrupt is not maskable?

TODO: use IDTR. Is initial value guaranteed?
*/

#include "common.h"
BEGIN
    CLEAR
    movw $handler, 0x00
    movw $0x00, 0x02
    mov $0x00, %ax
    div %ax
    jmp fail
handler:
    PUTC($0x61)
fail:
    hlt
END
