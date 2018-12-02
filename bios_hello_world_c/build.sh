#!/usr/bin/env bash
set -eux
as -ggdb3 -o entry.o entry.S
gcc -c -ggdb3 -nostartfiles -nostdlib -o main.o main.c
ld                  -o main.elf -T linker.ld entry.o main.o
ld --oformat binary -o main.img -T linker.ld entry.o main.o
qemu-system-x86_64 -hda main.img
