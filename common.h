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
    cli
    /* Tell the processor where our Global Descriptor Table is in memory. */
    lgdt gdt_descriptor

    /* Set PE (Protection Enable) bit in CR0 (Control Register 0) */
    mov %cr0, %eax
    orl $0x1, %eax
    mov %eax, %cr0

    /* TODO why does equ not work? What is the alternative? */
    /*ljmp $CODE_SEG, $b32*/
    /*
    This is needed to set `%cs` to 8.

    8 means the second entry, since each entry is 8 bytes wide,
    and we have an initial null entry.
    */
    ljmp $0x08, $protected_mode
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
.equ CODE_SEG, gdt_code - gdt_start
.equ DATA_SEG, gdt_data - gdt_start
protected_mode:
    /* Setup the other segments. */
    mov $DATA_SEG, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
    /* TODO: what is the maximum we can put were? Why does `FFFFFFFF` fail? */
    mov $0XFFFFFF00, %ebp
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
Output: two ASCII characters, is stored in `al:bl`
Clobbers: ax
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

Clobbers: eax, ecx, edx
*/
.macro VGA_PRINT s
    LOCAL loop, end
    mov s, %ecx
    /* Video memory address. */
    mov $0xb8000, %edx
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
.endm
