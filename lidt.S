#include "common.h"
BEGIN
    CLEAR
    cli
    movw $handler, idt_start
    mov %cs, idt_start + 2
    lidt idt_descriptor
    int $0
    PUTC $'b
    hlt
idt_start:
    .word handler
    .word
idt_end:
idt_descriptor:
    .word idt_end - idt_start
    .long idt_start
handler:
    PUTC $'a
    iret
