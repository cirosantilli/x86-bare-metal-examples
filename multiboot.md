# Multiboot

<https://en.wikipedia.org/wiki/Multiboot_Specification>

Standard created by GRUB for booting OSes.

Multiboot files are an extension of ELF files with a special header.

Advantages: GRUB does housekeeping magic for you:

- you can store the OS as a regular file inside a filesystem
- your program starts in 32-bit mode already, not 16 bit real mde

Disadvantages:

- more boilerplate

GRUB leaves the application into a well defined starting state.

Implemented by Linux and many NIXes, but not Windows or Mac.

Use `grub-mkrescue` to make a multiboot file into a bootable disk.
