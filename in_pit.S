/*
# PIT

TODO get working

TODO answer with example:

- http://stackoverflow.com/questions/13950264/does-using-tsc-as-clock-source-improve-timer-and-scheduling-granularity
- http://stackoverflow.com/questions/26853905/use-of-irq0-pit-in-x86-linux
- http://stackoverflow.com/questions/12229644/time-sources-in-x86-processors
- http://stackoverflow.com/questions/26321531/pit-not-sending-interrupts-to-irq0

TODO where is it documented?

Programmable interrupt timer.

Read this *now*: http://wiki.osdev.org/PIT

Can generate periodic interrupts, or sounds.

Has 3 channels that can generate 3 independent signals

- channel 0 at port 0x40: generates interrupts
- channel 1 at port 0x41: not to be used for some reason
- channel 2 at port 0x42: linked to the speaker to generate sounds

Port 0x43 is used to control signal properties except frequency
(which goes in the channel ports) for the 3 channels.
See osdev article for details.

## PIC

Programmable interrupt controller:

- http://wiki.osdev.org/PIC
- http://www.jamesmolloy.co.uk/tutorial_html/5.-IRQs%20and%20the%20PIT.html

Controls interrupts. Ports:

- 0x0020: Master PIC command
- 0x0021: Master PIC data
- 0x00A0: Slave PIC command
- 0x00A1: Slave PIC Data

### EOI

End of interrupt.

We must tell the PIC that we are at the end. TODO otherwise what?

https://en.wikipedia.org/wiki/End_of_interrupt

## 1193181

Magic number that is the frequency of the oscillator.

http://f.osdev.org/viewtopic.php?f=1&t=15503

Frequency divisor.

Produce 1000Hz signal.

1193181 is the source frequency.

This is an electronics concept:
https://en.wikipedia.org/wiki/Frequency_divider

2 occurrences on Linux 4.2.

## Bibliography

- https://en.wikipedia.org/wiki/Intel_8253
- http://kernelx.weebly.com/programmable-interval-timer.html
*/

#include "common.h"

BEGIN
    /* Setup interrupt handler 0. */
    movw $handler, 0x00
    mov %cs, 0x02

    /*
    Define the properties of the wave:

    - Channel: 0
    - access mode: lobyte/hibyte
    - operating mode: rate generator
    - BCD/binary: binary
    */
    mov $0b00110100, %al
    out %al, $0x43

    /*
    Set frequency of Channel 0.

    We have to split the 2 ax bytes,
    as we can only communicate one byte at a time here.
    */
    .equ div, 1193181 / 1000
    mov div, %ax
    out %al, $0x40
    mov %ah, %al
    out %al, $0x40

    PUTC($0x61)
    sti

loop:
    nop
    jmp loop

handler:
    PUTC($0x61)
    iret

    /* TODO turn off. */
