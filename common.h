/*
Using macros for everything to make linking simpler.

The big ones do bloat the executable.
*/

.altmacro

#define BEGIN \
    .code16;\
    cli;\
    xor %ax, %ax;\
    mov %ax, %ds

#define END

#define CURSOR_POSITION(x, y) \
    mov $0x02, %ah;\
    mov $0x00, %bh;\
    mov $0x ## x ## y, %dx;\
    int $0x10

/* Clear the screen, move to position 0, 0. */
#define CLEAR \
    mov $0x0600, %ax;\
    mov $0x7, %bh;\
    mov $0x0, %cx;\
    mov $0x184f, %dx;\
    int $0x10;\
    CURSOR_POSITION(0, 0)

/*
Print a single immediate byte or 8 bit register.

`c` is it's value in hex.

Usage: character 'A' (ASCII 61):

    PUTS(61)
*/
#define PUTC(c) \
    mov $0x0E, %ah;\
    mov c, %al;\
    int $0x10

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
/* We need a Gas macro for the LOCAL labels. */
.macro GAS_PRINT s
    LOCAL halt, loop
    mov s, %si
    mov $0x0e, %ah
loop:
    lodsb
    or %al, %al
    jz halt
    int $0x10
    jmp loop
halt:
.endm
