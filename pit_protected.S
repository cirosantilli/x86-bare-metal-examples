/*
# PIT protected mode

Unlike in real mode, for the protected mode to work well,
we have to setup the IDT properly.
TODO why? More maskable interrupts seem to be generated here by the PIC.

This handles all interrupts.
This is not very generic, because we don't know which interrupt number we are handling,
and cannot take the stack pushed error byte into account.
But it works for a very simple example.
*/

#include "common.h"
BEGIN
    STAGE2
    CLEAR
    PROTECTED_MODE

    mov $47, %ecx
setup_idt:
    IDT_SETUP_ENTRY <%ecx>, $handler
    loop setup_idt

    lidt idt_descriptor

    /*
    Remap the PIC interrupts to start at 32.
    TODO understand.
    */
    OUTB $0x11, PORT_PIC_MASTER_CMD
    OUTB $0x11, PORT_PIC_SLAVE_CMD
    OUTB $0x20, PORT_PIC_MASTER_DATA
    OUTB $0x28, PORT_PIC_SLAVE_DATA
    OUTB $0x04, PORT_PIC_MASTER_DATA
    OUTB $0x02, PORT_PIC_SLAVE_DATA
    OUTB $0x01, PORT_PIC_MASTER_DATA
    OUTB $0x01, PORT_PIC_SLAVE_DATA
    OUTB $0x00, PORT_PIC_MASTER_DATA
    OUTB $0x00, PORT_PIC_SLAVE_DATA

    OUTB $0b00110100, PORT_PIT_MODE
    PIT_SET_MIN_FREQ

    sti
    jmp .

IDT_START
.rept 48
IDT_ENTRY
.endr
IDT_END
handler:
    cli
    VGA_PRINT_STRING $message
    PIC_EOI
    sti
    iret
message:
    .asciz "interrupt"
