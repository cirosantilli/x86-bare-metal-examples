/*
Minimal interrupt example.

Should print the characters 'ab' to screen.

TODO: is STI not needed because this interrupt is not maskable?

TODO: use IDTR as a base. Is the initial value 0 guaranteed?
*/

#include "common.h"
BEGIN
    CLEAR
    movw $handler, 0x00
    movw $0x00, 0x02
    int $0
    PUTC($0x62)
    jmp end
handler:
    PUTC($0x61)
    /* Returns to the int instruction. */
    iret
end:
    hlt
END
