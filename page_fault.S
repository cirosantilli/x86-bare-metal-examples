/* https://github.com/cirosantilli/x86-bare-metal-examples#page-fault */

#include "common.h"

BEGIN
    CLEAR
    STAGE2
    PROTECTED_MODE
    IDT_SETUP_ENTRY $14, $interrupt_handler
    lidt idt_descriptor
    SETUP_PAGING_4M

    /* Make page 0 not present, so that any access to it will segfault. */
    andb $0xFE, page_table

    PAGING_ON
    /* Access page 0, generating a segfault. */
    movb $0, 0
    PAGING_OFF

    jmp .

IDT_START
IDT_SKIP 14
IDT_ENTRY
IDT_END
interrupt_handler:
    VGA_PRINT_STRING $message
    /* Mandatory because page faults push the error code to the stack.
     *
     * If we don't do this, then the stack will be wrong for iret,
     * likely leading to a general fault exception:
     * http://stackoverflow.com/questions/10581224/why-does-iret-from-a-page-fault-handler-generate-interrupt-13-general-protectio/33398064#33398064
     */
    pop %eax
    VGA_PRINT_HEX_4 <%eax>
    /* Make the page present. because iret will return to before the mov,
     * and we'd get and infinite loop.
     */
    orb $1, page_table
    iret
message:
    .asciz "Page fault handled. Error code:"
