/*
# Interrupt

Minimal interrupt example.

Expected outcome: 'ab' gets printed to the screen.

TODO: is STI not needed because this interrupt is not maskable?

TODO: interrupt priority: order looks like: 0, 1, 2, 8, 9, 10, 11, 12, 13, 14, 15, 3, 4, 5, 6, 7. What is that?

## int

What it does:

- long jumps to the CS : IP found in the corresponding interrupt vector.
- also pushes EFLAGS. Why? To let them be restored by iret?

## iret

Returns to the next instruction to be executed
before the interrupt came in.

I think this is mandatory, e.g. a `jmp` wouldn't be enough because:

- we may have far jumped
- iret also pops EFLAGS restoring. TODO more things also seem restored: CS, EIP, EFLAGS, SS, and ESP

http://stackoverflow.com/questions/10462884/must-iret-be-used-when-returning-from-an-interrupt

## ISR

## Interrupt service routines

Fancy name for the handler.

http://wiki.osdev.org/Interrupt_Service_Routines

## Interrupt descriptor table

## IDTR

## Interrupt descriptor table register

IDTR points to the IDT.

The IDT contains the list of callbacks for each interrupt.

This name seems to be reserved to 32-bit protected mode, IVT is the 16-bit term.

## IVT

http://wiki.osdev.org/IVT

osdev says that the default address is 0:0, and that it shouldn't be changed by LIDT,
as it is incompatible with older CPUs.
*/

#include "common.h"
BEGIN
    CLEAR
    movw $handler, 0x00
    mov %cs, 0x02
    int $0
    PUTC $'b
    hlt
handler:
    PUTC $'a
    iret
