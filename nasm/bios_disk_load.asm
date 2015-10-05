use16
org 0x7C00

    ; Load stage 2 to memory.
    mov ah, 0x02
    mov al, 1
    mov dl, 0x80
    mov ch, 0
    mov dh, 0
    mov cl, 2
    mov bx, stage2
    int 0x13

    jmp stage2

    times ((0x200 - 2) - ($ - $$)) db 0x00
    dw 0xAA55

stage2:

    mov si, msg
    mov ah, 0x0E
for_each_char:
    lodsb
    cmp al, 0x00
    je end_for_each_char
    int 0x10
    jmp for_each_char
end_for_each_char:

    cli
    hlt

    msg: db 'second stage', 0

    times ((0x400) - ($ - $$)) db 0x00
