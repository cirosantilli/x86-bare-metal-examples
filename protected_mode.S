/*
# Protected mode

Major changes from real moe:

-   BIOS cannot be used anymore

-   GDT and segmentation take effect immediately so we *have*
    to deal with it now.

-   we have to encode instructions differently, thus a `.code32` is needed.
    Note that in 16-bit, 32-bit instructions were encodable, but with a prefix.

## Linux kernel

arch/x86/include/asm/segment.h contains a lot of action:

- the user privilege level
- the segment steup (kernel an user code and data segments)

## Bibliography

- http://stackoverflow.com/questions/28645439/how-do-i-enter-32-bit-protected-mode-in-nasm-assembly Initially adapted from this.
- http://wiki.osdev.org/Journey_To_The_Protected_Land
- http://wiki.osdev.org/Protected_Mode
- https://github.com/chrisdew/xv6/blob/master/bootasm.S
- https://thiscouldbebetter.wordpress.com/2011/03/17/entering-protected-mode-from-assembly/ FASM based. Did not word on first try, but looks real clean.
- http://skelix.net/skelixos/tutorial02_en.html
*/

#include "common.h"

BEGIN
    CLEAR
    PROTECTED_MODE
    VGA_PRINT_STRING $message
    jmp .
message:
    .asciz "hello world"
