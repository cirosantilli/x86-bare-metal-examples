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
Print a single character.

`c` is it's value in hex.
*/
#define PUTC(c) \
    mov $0x0E ## c, %ax;\
    int $0x10
