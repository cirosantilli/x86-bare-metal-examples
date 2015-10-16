; 2-stage protected mode entry.
;
; Initially taken from:
; https://thiscouldbebetter.wordpress.com/2011/03/17/entering-protected-mode-from-assembly/
;
; This works on QEMU, but I don't trust the expertize of that author very much.
; E.g., this does not have any `[BITS 32]`?

use16
org 0x7C00

    mov ah, 0x00
    mov dl, 0
    int 0x13

    mov ah, 0x02
    mov al, 0x10
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

    ; Set up data for entering protected mode.
    xor edx, edx ; edx = 0
    mov dx, ds   ; get the data segment
    shl edx, 4   ; shift it left a nibble
    add [gdt+2], edx ; GDT's base addr = edx

    lgdt [gdt]   ; load the GDT
    mov eax, cr0 ; eax = machine status word (MSW)
    or al, 1     ; set the protection enable bit of the MSW to 1
    cli
    mov cr0, eax ; start protected mode

    mov bx, 0x08 ; the size of a GDT descriptor is 8 bytes
    mov fs, bx   ; fs = the 2nd GDT descriptor, a 4 GB data seg

    ; Write a status message.
    mov ebx, 0xB8000 ; address of first char for VGA mode 3
    mov si, message  ; si = message text

for_each_char:

    lodsb
    cmp al, 0x00
    je end_for_each_char
    mov [fs:ebx], al
    inc ebx
    inc ebx
    jmp for_each_char

end_for_each_char:

loop_forever:

    jmp loop_forever
    ret
    message: db 'hello world', 0

gdt:

    ; the global descriptor table is the heart of protected mode
    ; entries are used to map virtual to physical memory
    ; among other things
    ;
    ; each descriptor contains 8 bytes, "organized" as follows:
    ;
    ; |----------------------2 bytes--------------------|
    ;
    ; +-------------------------------------------------+
    ; | segment address 24-31  | flags #2  | len 16-19  | +6
    ; +-------------------------------------------------+
    ; | flags #1               | segment address 16-23  | +4
    ; +-------------------------------------------------+
    ; | segment address bits 0-15                       | +2
    ; +-------------------------------------------------+
    ; | segment length bits 0-15                        | +0
    ; +-------------------------------------------------+

    ; the high-order bit of flags #2 controls "granularity"
    ; setting it to 1 multiplies the segment length by 4096

    ;======================================================

    ; create two descriptors:
    ; one for the GDT itself, plus a 4 gibabyte data segment

    dw gdt_end - gdt - 1
    ; segment address bits 0-15, 16-23
    dw gdt
    db 0
    ; flags 1, segment length 16-19 + flags 2
    db 0, 0
    ; segment address bits 24-31
    db 0

    ; a data segment based at address 0, 4 gibabytes long
    dw 0xFFFF   ; segment length 0-15
    db 0, 0, 0  ; segment address 0-15, 16-23
    db 0x91     ; flags 1
    db 0xCF     ; flags 2, segment length 16-19
    db 0        ; segment address 24-31

gdt_end:

    times (0x2000 - ($ - $$)) db 0x00
