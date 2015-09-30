/*
https://courses.engr.illinois.edu/ece390/books/labmanual/io-devices-speaker.html

TODO not working on QEMU
*/

#include "common.h"
BEGIN
start:
    PUTC($0x61)

    movb    $182,%al        # Prepare the speaker for the
    outb    %al, $0x43       #  note.
    movw    $4560,%ax       # Frequency number (in decimal)
                            #  for middle C.
    outb    %al, $0x42       # Output low byte.
    movb    %ah,%al         # Output high byte.
    outb    %al, $0x42
    inb     $0x61,%al       # Turn on note (get value from
                            #  port 61h).
    orb     $0b00000011,%al # Set bits 1 and 0.
    outb    %al, $0x61       # Send new value.
    movw    $25,%bx         # Pause for duration of note.
.pause1:
    movw    $65535,%cx
.pause2:
    decw    %cx
    jne     .pause2
    decw    %bx
    jne     .pause1
    inb     $0x61,%al       # Turn off note (get value from
                            #  port 61h).
    andb    $0b11111100,%al # Reset bits 1 and 0.
    outb    %al, $0x61       # Send new value.

    jmp start
END
