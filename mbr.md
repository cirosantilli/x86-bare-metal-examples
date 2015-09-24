# MBR

A major type of boot sector.

Wiki page describes it well enough: <https://en.wikipedia.org/wiki/Master_boot_record>

TODO where is it specified, if at all?

## Gotchas

-   bytes 511 and 512 of the boot sector must be `0x55aa` or else the BIOS will refuse to load

-   BIOS loads the program into memory at the address `0x7C00`.

    Note that this is not the first address that the RIP is set to run: I think all jobs up to now are done by the CPU: the first address seems to be `FFFF:0000` instead: <http://stackoverflow.com/a/32686533/895245>

    We must tell that magic number to the linker somehow, either with a linker script, `-tText=-Ttext 0x7C00` or NASM `org 0x7c00`.

    This will only matter when you access a memory address, because of relocation.

    If you don't know what relocation is, first read this: <http://stackoverflow.com/questions/12122446/how-does-c-linking-work-in-practice/30507725#30507725>

    When we link a normal program with an OS, the linker tells where it wants the OS to place it in virtual memory.

    But for the boot sector, the BIOS puts the program into memory. So we must tell that to the linker somehow. Otherwise it cannot know what addresses to use for instructions.

-   x86 processors start in 16-bit mode.
