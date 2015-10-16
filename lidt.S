/*
# lidt

TODO get working:

- http://wiki.osdev.org/Real_Mode

Sets the IDTR through a from a descriptor in memory, and tells the CPU where the IDT is on memory.

Expected outcome: 'ab' gets printed to the screen.

osdev says this is not compatible with older CPUs.

# sidt

Read the descriptor register to memory.
*/

#include "common.h"
BEGIN
    CLEAR

    lidt idt_descriptor

    movw $handler, 0x04
    mov %cs, 0x06

    int $0
    PUTC($0x62)
    hlt

idt:
    .word 2
    .word 4
idt_end:

idt_descriptor:
    .word idt_end - idt
    .long idt

handler:
    PUTC($0x61)
    iret
