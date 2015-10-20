/*
Using macros for everything to make linking simpler.

The big ones do bloat the executable.

## Calling convention
*/

.altmacro

.macro BEGIN
    .code16
    cli
    /* Set %cs to 0. TODO Is that really needed? */ ;\
    ljmp $0, $1f
    1:
    xor %ax, %ax
    /* We must zero %ds for any data access. */ \
    mov %ax, %ds
    /* TODO is it really need to clear all those segment registers, e.g. for BIOS calls? */ \
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    /* TODO What to move into BP and SP? http://stackoverflow.com/questions/10598802/which-value-should-be-used-for-sp-for-booting-process */ \
    mov 0x0000, %bp
    /* Automatically disables interrupts until the end of the next instruction. */ \
    mov %ax, %ss
    /* We should set SP because BIOS calls may depend on that. TODO confirm. */ \
    mov %bp, %sp
.endm

/*
Load stage2 from disk to memory, and jump to it.

TODO not working.

To be used when the program does not fit in the 512 bytes.

Sample usage:

    STAGE2
    Stage 2 code here.
*/
.macro STAGE2
    mov $2, %ah
    /*
    TODO get working on linker script.
    Above my paygrade for now, so I just load a bunch of sectors instead.
    */
    /* mov __stage2_size, %al;\ */
    mov $9, %al
    mov $0x80, %dl
    mov $0, %ch
    mov $0, %dh
    mov $2, %cl
    mov $1f, %bx
    int $0x13
    jmp 1f
    .section .stage2
    1:
.endm

/*
Enter protected mode.

Use the simplest GDT possible.
*/
.macro PROTECTED_MODE
    /* Must come before they are used. */
    .equ CODE_SEG, 8
    .equ DATA_SEG, gdt_data - gdt_start

    cli
    /* Tell the processor where our Global Descriptor Table is in memory. */
    lgdt gdt_descriptor

    /*
    Set PE (Protection Enable) bit in CR0 (Control Register 0),
    effectively entering protected mode.
    */
    mov %cr0, %eax
    orl $0x1, %eax
    mov %eax, %cr0

    ljmp $CODE_SEG, $protected_mode
.code32
gdt_start:
gdt_null:
    .long 0x0
    .long 0x0
gdt_code:
    .word 0xffff
    .word 0x0
    .byte 0x0
    .byte 0b10011010
    .byte 0b11001111
    .byte 0x0
gdt_data:
    .word 0xffff
    .word 0x0
    .byte 0x0
    .byte 0b10010010
    .byte 0b11001111
    .byte 0x0
gdt_end:
gdt_descriptor:
    .word gdt_end - gdt_start
    .long gdt_start
vga_current_line:
    .long 0
protected_mode:
    /*
    Setup the other segments.
    Those movs are mandatory because they update the descriptor cache:
    http://wiki.osdev.org/Descriptor_Cache
    */
    mov $DATA_SEG, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
    /* TODO detect memory properly. */
    mov $0X7000, %ebp
    mov %ebp, %esp
.endm

/* BIOS */

#define CURSOR_POSITION(x, y) \
    mov $0x02, %ah;\
    mov $0x00, %bh;\
    mov $0x ## x ## y, %dx;\
    int $0x10

/* Clear the screen, move to position 0, 0. */
.macro CLEAR
    mov $0x0600, %ax
    mov $0x7, %bh
    mov $0x0, %cx
    mov $0x184f, %dx
    int $0x10
    CURSOR_POSITION(0, 0)
.endm

/*
Print a single immediate byte or 8 bit register.

`c` is it's value in hex.

Usage: character 'A' (ASCII 61):

    PUTS(61)

Clobbers: ax
*/
#define PUTC(c) \
    mov $0x0E, %ah;\
    mov c, %al;\
    int $0x10

/*
Convert a byte to hex ASCII value.
c: r/m8 byte to be converted
Output: two ASCII characters, is stored in `ah:al`
http://stackoverflow.com/questions/3853730/printing-hexadecimal-digits-with-assembly
*/
#define HEX(c) GAS_HEX c
.macro GAS_HEX c
    mov \c, %al
    mov \c, %ah
    shr $4, %al
    GAS_HEX_NIBBLE al
    and $0x0F, %ah
    GAS_HEX_NIBBLE ah
.endm

/*
Convert the low nibble of a r8 reg to ASCII of 8-bit in-place.
reg: r8 to be converted
Clobbered registers: none
Output: stored in reg itself. Letters are uppercase.
*/
.macro GAS_HEX_NIBBLE reg
    LOCAL letter, end
    cmp $10, %\reg
    jae letter
    /* 0x30 == '0' */
    add $0x30, %\reg
    jmp end
letter:
    /* 0x37 == 'A' - 10 */
    add $0x37, %\reg
end:
.endm

/*
Print a byte as two hexadecimal digits.

reg: 1 byte register.

Clobbers: ax, dl
*/
#define PRINT_HEX(reg) \
    HEX(<reg>);\
    mov %ah, %dl;\
    PUTC(%al);\
    PUTC(%dl)

#define PRINT_NEWLINE \
    PUTC($0x0A);\
    PUTC($0x0D)

/*
Print a null terminated string.

Use as:

        PRINT($s)
        hlt
    s:
        .asciz "string"

We use this `cpp` macro to allow writing `PRINT(S)` with parenthesis.
*/
#define PRINT(s) GAS_PRINT s
.macro GAS_PRINT s
    LOCAL loop, end
    mov s, %si
    mov $0x0e, %ah
loop:
    lodsb
    or %al, %al
    jz end
    int $0x10
    jmp loop
end:
.endm

/* VGA */

/*
Print a NULL terminated string to position 0 in VGA.

s: 32-bit register or memory containing the address of the string to print.

Clobbers: none.

Uses and updates vga_current_line to decide the current line.
Loops around the to the top.
*/
.macro VGA_PRINT_STRING s
    LOCAL loop, end
    push %eax
    push %ebx
    push %ecx
    push %edx
    mov \s, %ecx
    mov vga_current_line, %eax
    mov $0, %edx
    /* Number of horizontal lines. */
    mov $25, %ebx
    div %ebx
    mov %edx, %eax
    /* 160 == 80 * 2 == line width * bytes per character on screen */
    mov $160, %edx
    mul %edx
    /* 0xb8000 == magic video memory address which shows on the screen. */
    lea 0xb8000(%eax), %edx
    /* White on black. */
    mov $0x0f, %ah
loop:
    mov (%ecx), %al
    cmp $0, %al
    je end
    mov %ax, (%edx)
    add $1, %ecx
    add $2, %edx
    jmp loop
end:
    incl vga_current_line
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
.endm

/*
Print a 32-bit register in hex.

Sample usage:

    mov $12345678, %eax
    VGA_PRINT_REG <%eax>

Expected output on screen:

    12345678
*/
.macro VGA_PRINT_REG reg=<%eax>
    LOCAL loop
    push %eax
    push %ebx
    push %ecx
    push %edx
    /* Null terminator. */
    mov \reg, %ecx

    /* Write ASCII representation to memory. */
    push $0
    mov $2, %ebx
loop:
    GAS_HEX <%cl>
    mov %ax, %dx
    shl $16, %edx
    GAS_HEX <%ch>
    mov %ax, %dx
    push %edx
    shr $16, %ecx
    dec %ebx
    cmp $0, %ebx
    jne loop

    /* Print it. */
    mov %esp, %edx
    VGA_PRINT_STRING <%edx>

    /* Restore the stack. We have pushed 3 * 4 bytes. */
    add $12, %esp
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
.endm
