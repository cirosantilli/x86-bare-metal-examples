.code16
.text
.global mystart
mystart:
    ljmp $0, $.setcs
.setcs:
    xor %ax, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %ss
    mov $__stack_top, %esp
    cld
    call main
