; http://stackoverflow.com/a/28645943/895245

[bits 16]
[org 0x7c00]

    mov ax, 0
    mov ss, ax
    mov sp, 0xFFFC
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    ; TODO why is this needed?
    jmp CODE_SEG:b32

[bits 32]

print32:
    pusha
    ; Video memory address.
    mov edx, 0xb8000
.loop:
    mov al, [ebx]
    ; White on black.
    mov ah, 0x0f
    cmp al, 0
    je .done
    mov [edx], ax
    add ebx, 1
    add edx, 2
    jmp .loop
.done:
    popa
    ret

b32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov ebp, 0x2000
    mov esp, ebp

    mov ebx, message
    call print32

    jmp $

gdt_start:

gdt_null:
    dd 0x0
    dd 0x0

gdt_code:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0

gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

message db 'hello world', 0

[SECTION signature start=0x7dfe]
dw 0AA55h
