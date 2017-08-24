# Multiboot

1.  [hello-world](hello-world/)
1.  [osdev](osdev/)

## Usage

QEMU supports multiboot natively <https://stackoverflow.com/questions/25469396/how-to-use-qemu-properly-with-multi-boot-headers/32550281#32550281>:

    cd hello-world
    make
    qemu-system-x86_64 -kernel main.elf

Or you can use `grub-mkrescue` to make a multiboot file into a bootable ISO or disk:

    qemu-system-x86_64 -hda main.img

Outcome: `hello world` shows on screen.

## Introduction

<https://en.wikipedia.org/wiki/Multiboot_Specification>

Standard created by GRUB for booting OSes.

Multiboot files are an extension of ELF files with a special header.

Advantages: GRUB does housekeeping magic for you:

- you can store the OS as a regular file inside a filesystem
- your program starts in 32-bit mode already, not 16 bit real mode
- it gets the available memory ranges for you

Disadvantages:

- more boilerplate

GRUB leaves the application into a well defined starting state.

It seems that Linux does not implement Multiboot natively, but GRUB supports it as an exception: <http://stackoverflow.com/questions/17909429/booting-a-non-multiboot-kernel-with-grub2>
