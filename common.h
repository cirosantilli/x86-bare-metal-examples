#define BEGIN .code16; \
    cli; \
    mov $0x0000, %ax; \
    mov %ax, %ds
#define END
