/*
# SMP
*/

#include "common.h"
BEGIN

    /*
    Setup the code that will be run
    on the other processors when they start up.
    */
    mov $init_len, %ecx
    mov $init, %esi
    mov $0xFFFFFFF0, %edi
    rep movsb

    /*
    Destination Shorthand = 11 = all except self
    Trigger Mode = ?
    Level = ?
    Delivery Status = 0 = Idle
    Destination Mode = ? = Does not matter since shorthand used
    Delivery Mode = 110 = Startup
    Vector = ? = does it matter for SIPI?
    */
    movl $0x000C0600, 0xFEE00300

    /* Busy loop until another thread changes this memory. */
    movb $0, 0x2000
not_started:
    cmpb $1, 0x2000
    jne not_started
    PUTC $'a
    hlt
init:
    movl $1, 0x2000
    hlt
.equ init_len, . - init
