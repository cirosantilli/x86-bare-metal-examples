/*
# PIT

Programmable interrupt timer.

Expected output: "a\n" is printed infinitely many times.

Generates periodic interrupts (or sound!) with a given frequency to IRQ0,
which on real mode maps to interrupt 8 by default.

Major applicaiton: interrupt the running process
to allow the OS to schedule processes.

Read this *now*: http://wiki.osdev.org/PIT

Has 3 channels that can generate 3 independent signals

- channel 0 at port 0x40: generates interrupts
- channel 1 at port 0x41: not to be used for some reason
- channel 2 at port 0x42: linked to the speaker to generate sounds

Port 0x43 is used to control signal properties except frequency
(which goes in the channel ports) for the 3 channels.
See osdev article for details.

## Frequency

## 1193181

We don't control the frequency of the PIT directly,
which is fixed at 1193181.

Instead, we control a frequency divisor.
This is an well known type of discrete electronic circuit:
https://en.wikipedia.org/wiki/Frequency_divider

1193181 has 2 occurrences on Linux 4.2.

## Bibliography

- https://en.wikipedia.org/wiki/Intel_8253 That is the circuit ID for the PIT.
- http://kernelx.weebly.com/programmable-interval-timer.html
*/

#include "common.h"

BEGIN
    /* Setup interrupt handler 8: this is where the PIC maps IRQ 0 to. */
    movw $handler, 8 * 4
    mov %cs, 8 * 4 + 2

    /*
    Define the properties of the wave:

    - Channel: 0
    - access mode: lobyte/hibyte
    - operating mode: rate generator
    - BCD/binary: binary
    */
    OUTB $0b00110100, $0x43

    /*
    Set frequency of Channel 0.

    We have to split the 2 ax bytes,
    as we can only communicate one byte at a time here.
    */
    /* If we wanted an approximate frequency, we'd use: */
    /*
    .equ div, 1193181 / 1000
    mov div, %ax
    out %al, $0x40
    mov %ah, %al
    out %al, $0x40
    */

    /* Instead, let's just use the smallest frequency possible. */
    mov $0xFF, %al
    out %al, $0x40
    out %al, $0x40

    sti

    jmp .

handler:
    cli
    PUTC $'a
    PUTC $'\n
    /* EOI: it will not fire again unless we reset it. */
    OUTB PIC_CMD_RESET, PORT_PIC_MASTER_CMD
    sti
    iret

    /* TODO turn off. */
