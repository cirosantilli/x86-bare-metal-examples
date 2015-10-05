/*
TODO not working on QEMU, but does produce some horrible sound on real hard.
Maybe because I cannot get the beep working on my Ubuntu host?
http://askubuntu.com/questions/19906/beep-in-shell-script-not-working

It looks like the beep (port 0x61) just uses
the PIT Channel 2 to generate the frequency, so understand the PIT first.

Extracted from:
https://github.com/torvalds/linux/blob/v4.2/arch/x86/realmode/rm/wakemain.c#L38
The kernel has a Morse code encoder with it!

Not using io_delay here, maybe would sound better with it?

See also:

- http://fly.srk.fer.hr/GDM/articles/sndmus/speaker1.html

## Port 0x61

http://wiki.osdev.org/PC_Speaker

Speaker specifics are there.
The 0x4X IO are the PIT.
*/

#include "common.h"

BEGIN
    /* Chanel 2, square wave, load TODO?, binary */
    mov $0xb6, %al
    out %al, $0x43

    /* Set frequency of Channel 2. */
    .equ div, 1193181 / 1000
    mov div, %ax
    out %al, $0x42
    mov %ah, %al
    out %al, $0x42

    /* Dummy read of System Control Port B. TODO why? */
    in $0x61, %al

    /*
    Enable timer 2 output to speaker.

    THIS is where the sound begins.
    */
    mov $0x03, %al
    out %al, $0x61

    /* Loop forever to keep hearing it. */
loop:
    nop
    jmp loop

    /*
    This is how a sound can be stopped.

    This code never runs in this example.
    */
	in $0x61, %al
    mov $0x00, %al
    out %al, $0x61
