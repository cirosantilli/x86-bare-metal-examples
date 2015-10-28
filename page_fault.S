/*
# Page fault

Generate and handle a page fault.

Expected output:

    Page fault handled. Error code:
    00000002

## Error code
*/

#include "common.h"

BEGIN
    CLEAR
    STAGE2
    PROTECTED_MODE
    IDT_SETUP_ENTRY $14, $handler
    lidt idt_descriptor
    SETUP_PAGING_4M

    /* Make page 0 not present, so that any access to it will segfault. */
    mov page_table, %eax
    and $0xFFFFFFFE, %eax
    mov %eax, page_table

    PAGING_ON
    /* Access page 0, generating a segfault. */
    mov %eax, 0
    PAGING_OFF

    jmp .

IDT_START
IDT_SKIP 14
IDT_ENTRY
IDT_END
handler:
    VGA_PRINT_STRING $message
    /*
    Mandatory because page faults push the error code to the stack.
    If we don't do this, then the stack will be wrong for iret, likely leading to a general fault exception:
    http://stackoverflow.com/questions/10581224/iret-with-13-interruptgeneral-protection-fault-and-error-0x18
    */
    pop %eax
    VGA_PRINT_HEX_4 <%eax>
    /* Make the page present. because iret will return to before the mov, and we'd get and infinite loop. */
    mov page_table, %eax
    or $1, %eax
    mov %eax, page_table
    iret
message:
    .asciz "Page fault handled. Error code:"
