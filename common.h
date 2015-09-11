#define BEGIN .code16; \
    cli; \
    xor %ax, %ax; \
    mov %ax, %ds
#define END
