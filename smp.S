/*
# SMP

Expected output: "SMP started"

TODO get working + answer all of:

- http://stackoverflow.com/questions/16364817/assessing-the-apic-and-creating-ipis-in-x86-assembly
    Closest quesiton so far! Almost there!
    Table 8-1. Broadcast INIT-SIPI-SIPI Sequence and Choice of Timeouts contains actual code!
    TODO: how to sleep the right ammount of time?
- http://stackoverflow.com/questions/15091165/inter-processor-interrupt-usage
- http://stackoverflow.com/questions/1516530/assembly-and-multicore-cpus?lq=1
- http://stackoverflow.com/questions/1622388/running-code-on-different-processor-x86-assembly
- http://stackoverflow.com/questions/26452323/how-can-we-use-multi-core-and-cpu-on-assembly-boot-loader-x86
- http://stackoverflow.com/questions/2986931/the-way-cores-processes-and-threads-work-exactly?rq=1
- http://stackoverflow.com/questions/419486/multithreading-and-interrupts
- http://stackoverflow.com/questions/663958/how-to-control-which-core-a-process-runs-on
- http://stackoverflow.com/questions/714905/threads-in-x86-assembler-using-the-gnu-assember-as
- http://stackoverflow.com/questions/7308391/how-is-concurrency-done-in-intel-x86-assembly
- http://stackoverflow.com/questions/980999/what-does-multicore-assembly-language-look-like
- http://stackoverflow.com/questions/28047092/by-which-instruction-the-secondary-core-is-triggered-while-starting-the-secondar?rq=1
- http://stackoverflow.com/questions/23962839/how-to-correctly-use-a-startup-ipi-to-start-an-application-processor?rq=1
- https://github.com/cirosantilli/oszur11-operating-system-examples/tree/1af6451852887fac3d7206d4d09714c181c81d1e/Chapter_07_Threads
*/

/* Must be a multiple of 0x1000. */
.equ STARTUP_CODE_ADDRESS, 0x1000
.equ SPINLOCK_ADDRESS, 0x2000

#include "common.h"
BEGIN
    STAGE2
    CLEAR
    /*
    TODO do we need 32-bit mode? I think yes because the APIC register
    FEE00300 is too high for 16-bit?
    */
    PROTECTED_MODE
    IDT_SETUP_48_ISRS
    REMAP_PIC_32
    PIT_GENERATE_FREQUENCY
    /* Each tick is 20us. */
    PIT_SET_FREQ 50000
    sti

    /*
    Setup the code that will be run
    on the other processors when they start up.
    Should be somewhere into the first 1Mb,
    as processors starte in real mode.
    */
    cld
    mov $init_len, %ecx
    mov $init, %esi
    mov $STARTUP_CODE_ADDRESS, %edi
    rep movsb

    /* Setup the value that threads will modify for us. */
    movb $0, SPINLOCK_ADDRESS

    /*
    Move data into the lower ICR register:
    this should start the other processors.
    - Destination Shorthand = 11 = all except self
    - Trigger Mode = ?
    - Level = ?
    - Delivery Status = 0 = Idle
    - Destination Mode = ? = Does not matter since shorthand used
    - Delivery Mode = 110 = Startup
    - Vector = ? = does it matter for SIPI?
    */

    /* Load address of ICR low dword into ESI. */
    mov PIC_ICR_ADDRESS, %esi
    /* Load ICR encoding for broadcast INIT IPI to all APs. */
    mov $0x000C4500, %eax
    /* Broadcast INIT IPI to all APs */
    mov %eax, (%esi)
    /* 10-millisecond delay loop. */
    PIT_SLEEP_TICKS $500
    /*
    Load ICR encoding for broadcast SIPI IP to all APs.
    The low byte of this is the vector which encodes the staring address for the processors!
    This address is multiplied by 0x1000: processors start at CS = vector * 0x100 and IP = 0.
    */
    mov $0x000C4600 + STARTUP_CODE_ADDRESS / 0x1000, %eax
    /* Broadcast SIPI IPI to all APs. */
    mov %eax, (%esi)
    /* 200-microsecond delay loop. */
    PIT_SLEEP_TICKS $10
    /* Broadcast second SIPI IPI to all APs */
    mov %eax, (%esi)

    /* TODO improve this spinlock. */
not_started:
    cmpb $1, SPINLOCK_ADDRESS
    jne not_started

    VGA_PRINT_STRING $message
    /* Testing if it is possible in 16-bit real mode. */
    /*PRINT_STRING $message*/
    hlt
message:
    .asciz "SMP started"
IDT_48_ENTRIES
PIT_SLEEP_TICKS_GLOBALS
interrupt_handler:
    cmp PIT_ISR_NUMBER, 4(%esp)
    jne not_pit
    PIT_SLEEP_TICKS_HANDLER_UPDATE
not_pit:
    ret
.code16
init:
    xor %ax, %ax
    mov %ax, %ds
    movb $1, SPINLOCK_ADDRESS
    /* TODO mandatory? Is lock prefix enough? */
    wbinvd
    hlt
.equ init_len, . - init
