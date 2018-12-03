.code16
.text
.global mystart
mystart:
    mov %sp, __stack_top
    call main
