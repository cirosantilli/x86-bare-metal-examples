#include "common.h"
BEGIN
start:
    mov $0x00, %ah
    int $0x16
    PUTC <%al>
    jmp start
