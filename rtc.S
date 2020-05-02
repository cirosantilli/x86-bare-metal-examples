/* https://github.com/cirosantilli/x86-bare-metal-examples#rct */

/*
 * Reference: https://wiki.osdev.org/CMOS
	Register  Contents            Range
	0x00      Seconds             0–59
	0x02      Minutes             0–59
	0x04      Hours               0–23 in 24-hour mode, 
				      1–12 in 12-hour mode, highest bit set if pm
	0x07      Day of Month        1–31
	0x08      Month               1–12
	0x09      Year                0–99

	0x0A      Status Register A
	RTC has an "Update in progress" flag (bit 7 of Status Register A). 
	To read the time and date properly you have to wait until 
	the "Update in progress" flag goes from "set" to "clear". 
*/ 
.equ RTCaddress, 0x70
.equ RTCdata, 0x71

#include "common.h"
BEGIN
update_in_progress:
    mov $0x0A, %al
    out %al, $RTCaddress
    in $RTCdata, %al
    testb $0x80, %al
    jne update_in_progress

    /* Second. */
    mov $0x00, %al
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
