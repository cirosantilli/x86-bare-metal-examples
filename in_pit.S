/*
# PIT

TODO get working

TODO answer with example http://stackoverflow.com/questions/13950264/does-using-tsc-as-clock-source-improve-timer-and-scheduling-granularity

Programmable interrupt timer.

Can generate periodic interrupts, or sounds.

The kernel has a Morse code encoder with it. https://github.com/torvalds/linux/blob/v4.2/arch/x86/realmode/rm/wakemain.c#L38

Going to use in 0x40

## 1193181

Magic number that is the frequency of the oscillator.

http://f.osdev.org/viewtopic.php?f=1&t=15503

## Bibliography

- https://en.wikipedia.org/wiki/Intel_8253
- http://wiki.osdev.org/PIT
- http://kernelx.weebly.com/programmable-interval-timer.html
*/

#include "common.h"

#define PIT_CHANNEL0 $0x40
#define PIT_CHANNEL1 $0x41
#define PIT_CHANNEL2 $0x42
#define PIT_CMDREG $0x43

BEGIN
start:
    #u16 div = 1193181/hz;
    # Linux kernel
    #outb(0xb6, 0x43);    /* Ctr 2, squarewave, load, binary */
    #outb(div, 0x42);    /* LSB of counter */
    #outb(div >> 8, 0x42);    /* MSB of counter */
    #enable = 0x03;        /* Turn on speaker */
    #inb(0x61);        /* Dummy read of System Control Port B */
    #outb(enable, 0x61);    /* Enable timer 2 output to speaker */
END
