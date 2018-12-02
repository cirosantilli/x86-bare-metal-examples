.text
.global mystart
mystart:
    mov %rsp, __stack_top
    call main
    jmp .
