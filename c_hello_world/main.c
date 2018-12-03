void main(void) {
    int i;
    char s[] = "hello world";
    /* Add a bunch of debug prints to see if the control loop is correct. It is. */
    __asm__ ("mov $0x0E40, %ax; int $0x10");
    for (i = 0; i < sizeof(s); ++i) {
        __asm__ ("mov $0x0E41, %ax; int $0x10");
        __asm__ (
            "mov %0, %%ax; int $0x10"
            :
            : "m" (s[i])
            : "%ax"
        );
    }
    __asm__ ("mov $0x0E40, %ax; int $0x10");
    while (1) {
        __asm__ ("hlt");
    };
}
