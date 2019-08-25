/* https://github.com/cirosantilli/x86-bare-metal-examples#serial-uart */

#include "common.h"

#define PORT 0x3f8

BEGIN
    /* Initialize the serial. */
    /* Disable all interrupts */
    mov 0x00, %al
    mov $(PORT + 1), %dx
    out %al, %dx
    /* Enable DLAB (set baud rate divisor) */
    mov 0x80, %al
    mov $(PORT + 3), %dx
    out %al, %dx
    /* Set divisor to 3 (lo byte) 38400 baud */
    mov 0x03, %al
    mov $(PORT + 0), %dx
    out %al, %dx
    /* Set divisor to 3 (hi byte) 38400 baud */
    mov 0x00, %al
    mov $(PORT + 1), %dx
    out %al, %dx
    /* 8 bits, no parity, one stop bit */
    mov 0x03, %al
    mov $(PORT + 3), %dx
    out %al, %dx
    /* Enable FIFO, clear them, with 14-byte threshold */
    mov 0xC7, %al
    mov $(PORT + 2), %dx
    out %al, %dx
    /* IRQs enabled, RTS/DSR set */
    mov 0x0B, %al
    mov $(PORT + 4), %dx
    out %al, %dx

    mov $(PORT + 0), %dx
    mov $msg, %si
.Lloop:
    /* is_transmit_empty */
    mov $(PORT + 5), %dx
    inb %dx
    and $0x20, %al
    jz .Lloop

    /* Read value and check if NUL. */
    lodsb
    mov $0x01, %ah
    or %al, %al
    jz .Lhalt

    /* Send value to serial. */
    out %al, %dx

    /* Stop in infinite loop. */
    jmp .Lloop
.Lhalt:
    hlt
    jmp .Lhalt
msg:
    .asciz "hello world\n"
