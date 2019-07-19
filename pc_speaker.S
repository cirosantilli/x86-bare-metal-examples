/* https://github.com/cirosantilli/x86-bare-metal-examples#pc-speaker */

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

    /* Enable timer 2 output to speaker.
     * THIS is where the sound begins.
     */
    mov $0x03, %al
    out %al, $0x61

    /* Loop forever to keep hearing it. */
loop:
    nop
    jmp loop

    /* This is how a sound can be stopped.
     * This code never reached in this example.
     * unless you hack it up.
     */
	in $0x61, %al
    mov $0x00, %al
    out %al, $0x61
