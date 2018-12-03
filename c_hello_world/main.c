void main(void) {
    int i;
    char s[] = "hello world";
    for (i = 0; i < sizeof(s); ++i) {
        __asm__ (
            "mov %0, %%ax; int $0x10"
            :
            : "m" (s[i])
            : "%ax"
        );
    }
    while (1) {
        __asm__ ("hlt");
    };
}
