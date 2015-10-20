/*
# Detecte memory

# int 15

http://wiki.osdev.org/Detecting_Memory_%28x86%29

Determine how much memory you've got, and how much of it is low memory.

This is important in particular so that you can start your stack there
when you enter protected mode, since the stack grows down.

In 16-bit mode, it does not matter much,
since most modern machines have all addressable memory there.

`int 15` returns a list:
each time you call it a new memory region is returned.

## Low memory

TODO what is it?
*/

#include "common.h"
BEGIN
    mov $0xE820, %eax
    int $0x15

    hlt
