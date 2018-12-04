/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-detect-memory */

#include "common.h"
BEGIN
    CLEAR
    STAGE2
    mov $output, %di
    call do_e820

    /* Debug aid. */
    PRINT_WORD_HEX <%bp>
    PRINT_NEWLINE

    mov %bp, %ax
    mov $0, %dx
    /* Each entry is 24 bytes wide. */
    mov $24, %cx
    mul %cx
    PRINT_BYTES $output, <%ax>
    hlt

/* This was copy pasted from:
 * http://wiki.osdev.org/Detecting_Memory_%28x86%29#Getting_an_E820_Memory_Map
 *
 * use the INT 0x15, eax= 0xE820 BIOS function to get a memory map
 * inputs: es:di -> destination buffer for 24 byte entries
 * outputs: bp = entry count, trashes all registers except esi
 */
do_e820:
        xorl %ebx,%ebx          # ebx must be 0 to start
        xorw %bp,%bp            # keep an entry count in bp
        movl $0x0534D4150,%edx  # Place "SMAP" into edx
        movl $0xe820,%eax
        movl $1, %es:20(%di)
        movl $24,%ecx           # ask for 24 bytes
        int $0x15
        jc do_e820.failed       # carry set on first call means "unsupported function"
        movl $0x0534D4150,%edx  # Some BIOSes apparently trash this register?
        cmpl %edx,%eax          # on success, eax must have been reset to "SMAP"
        jne do_e820.failed
        testl %ebx,%ebx         # ebx = 0 implies list is only 1 entry long (worthless)
        je do_e820.failed
        jmp do_e820.jmpin
do_e820.e820lp:
        movl $0xe820,%eax       # eax, ecx get trashed on every int 0x15 call
        movl $1, %es:20(%di)
        movl $24,%ecx           # ask for 24 bytes again
        int $0x15
        jc do_e820.e820f        # carry set means "end of list already reached"
        movl $0x0534D4150,%edx  # repair potentially trashed register
do_e820.jmpin:
        jcxz do_e820.skipent    # skip any 0 length entries
        cmpb $20,%cl            # got a 24 byte ACPI 3.X response?
        jbe do_e820.notext
        testb $1, %es:29(%di)
        je do_e820.skipent
do_e820.notext:
        mov %ecx, %es:8(%di)
        or %ecx, %es:12(%di)
        jz do_e820.skipent      # if length uint64_t is 0, skip entry
        incw %bp                # got a good entry: ++count, move to next storage spot
        addw $24,%di
do_e820.skipent:
        testl %ebx,%ebx         # if ebx resets to 0, list is complete
        jne do_e820.e820lp
do_e820.e820f:
        #movw %bp,mmap_ent       # store the entry count
        clc                     # there is "jc" on end of list to this point, so the carry must be cleared
        ret
do_e820.failed:
        stc                     # "function unsupported" error exit
        ret

output:
