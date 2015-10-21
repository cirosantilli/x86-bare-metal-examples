/*
# in RTC

Real time clock.

Gives wall time with precision of seconds.

Uses a separate battery to keep going.

http://stackoverflow.com/questions/1465927/how-can-i-access-system-time-using-nasm

http://wiki.osdev.org/RTC

http://wiki.osdev.org/CMOS

Kenrel 4.2 usage: https://github.com/torvalds/linux/blob/v4.2/arch/x86/kernel/rtc.c#L121

## Milliseconds

Not possible. Must use the PIT.

## Time zone

QEMU uses UTC.
*/

#include "common.h"
BEGIN

/*
TODO what do those numbers mean? Where is this all documented?
*/
.equ RTCaddress, 0x70
.equ RTCdata, 0x71

update_in_progress:
    mov $10, %al
    out %al, $RTCaddress
    in $RTCdata, %al
    testb $0x80, %al
    jne update_in_progress

    /* Second. */
    mov $0, %al
    out %al, $RTCaddress
    in $RTCdata, %al

    /* Only print if second changed. */
    cmp %al, %cl
    je update_in_progress
    mov %al, %cl

    PRINT_HEX <%al>
    PUTC

    /* Minute. */
    mov $0x02, %al
    out %al, $RTCaddress
    in $RTCdata, %al
    PRINT_HEX <%al>
    PUTC

    /* Hour. */
    mov $0x04, %al
    out %al, $RTCaddress
    in $RTCdata, %al
    PRINT_HEX <%al>
    PUTC

    /* Day. */
    mov $0x07, %al
    out %al, $RTCaddress
    in $RTCdata, %al
    PRINT_HEX <%al>
    PUTC

    /* Month. */
    mov $0x08, %al
    out %al, $RTCaddress
    in $RTCdata, %al
    PRINT_HEX <%al>
    PUTC

    /* Year. */
    mov $0x09, %al
    out %al, $RTCaddress
    in $RTCdata, %al
    PRINT_HEX <%al>
    PRINT_NEWLINE

    jmp update_in_progress
