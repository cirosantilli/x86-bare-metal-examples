org 0x7c00
bits 16
cli
mov ax, 0x0E61
int 0x10
hlt
times 510 - ($-$$) db 0
dw 0xaa55
