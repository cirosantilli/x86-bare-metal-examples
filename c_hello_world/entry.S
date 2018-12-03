.code16
.text
.global mystart
mystart:
    mov $__stack_top, %sp
    call main
