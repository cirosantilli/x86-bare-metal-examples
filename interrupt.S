/*
Minimal interrupt example.

Should print the characters 'ab' to screen.

TODO: is STI not needed because this interrupt is not maskable?

TODO: use IDTR as a base. Is the initial value 0 guaranteed?

TODO: interrupt priority: order looks like: 0, 1, 2, 8, 9, 10, 11, 12, 13, 14, 15, 3, 4, 5, 6, 7

## iret

Returns to the next instruction to be executed
before the interrupt came in.
*/

#include "common.h"
BEGIN
    CLEAR
    movw $handler, 0x00
    movw %cs, 0x02
    int $0
    PUTC($0x62)
    jmp end
handler:
    PUTC($0x61)
    iret
end:
    hlt
END
