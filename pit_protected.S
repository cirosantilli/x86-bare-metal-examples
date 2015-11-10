/*
# PIT protected mode
*/

#include "common.h"
BEGIN
    STAGE2
    CLEAR
    PROTECTED_MODE
    IDT_SETUP_48_ISRS
    REMAP_PIC_32
    OUTB $0b00110100, PORT_PIT_MODE
    PIT_SET_MIN_FREQ
    sti
    jmp .
IDT_48_ENTRIES
interrupt_handler:
    pop %eax
    VGA_PRINT_HEX_4 <%eax>
    OUTB $0x61, $0x20
    PIC_EOI
    add $4, %esp
    sti
    iret
