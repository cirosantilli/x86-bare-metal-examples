# x86 Bare Metal Examples

Hello world examples of programs without an OS. A.K.A. bare bones.

1.  Examples
    1.  [printf](printf/)
    1.  [min](min.S)
    1.  [no-ld-script](no-ld-script/)
    1.  [bios_one_char](bios_one_char.S)
    1.  [bios_hello_world](bios_hello_world.S)
    1.  [shutdown_apm](shutdown_apm.S)
    1.  TODO not working
        1. [multiboot-c/](multiboot-c/)
        1. [UEFI](uefi/)
        1. [hajji](hajji)
    1.  [nasm](nasm/)
1.  [BIOS](bios.md)
1.  [Multiboot](multiboot.md)
1.  [TODO](TODO.md)

## Getting started

    sudo apt-get install build-essential qemu
    make run
    make run RUN=min
    make run RUN=bios_one_char

Tested on Ubuntu 14.04. TODO: get working on real hardware:

    sudo dd if=bios_hello_world.img of=/dev/sdX

into an USB did not work.

More assembly info at: <https://github.com/cirosantilli/assembly-cheat>

## Formats

When we create a regular Linux program, we generate an ELF file, which is read by the OS.

Without an OS, we can use the following formats:

-   boot sector. TODO where is it specified, if at all? Wiki page describes MBR well enough: <https://en.wikipedia.org/wiki/Master_boot_record>
-   multiboot. Defined by GRUB. More boilerplate, but much more convenient.

## Gotchas

-   bytes 511 and 512 of the boot sector must be `0x55aa` or else the BIOS will refuse to load

-   BIOS loads the program into memory at the address `0x7C00`.

    We must tell that magic number to the linker somehow, either with a linker script, `-tText=-Ttext 0x7C00` or NASM `org 0x7c00`.

    This will only matter when you access a memory address, because of relocation.

    If you don't know what relocation is, first read this: <http://stackoverflow.com/questions/12122446/how-does-c-linking-work-in-practice/30507725#30507725>

    When we link a normal program with an OS, the linker tells where it wants the OS to place it in virtual memory.

    But for the boot sector, the BIOS puts the program into memory. So we must tell that to the linker somehow. Otherwise it cannot know what addresses to use for instructions.

-   x86 processors start in 16-bit mode.

## IO

You cannot use any libraries, so how to do IO? Some ways that this can be done:

- BIOS functions: <http://wiki.osdev.org/BIOS>. Not well standardized like it's successor UEFI. Called through interrupts.
- <https://en.wikipedia.org/wiki/VGA-compatible_text_mode>
- VBE <https://en.wikipedia.org/wiki/VESA_BIOS_Extensions>

Showdown and restart can be managed with either:

-   ACPI <https://en.wikipedia.org/wiki/Advanced_Configuration_and_Power_Interface>

    Newer and better.

    Now managed by the same group that manages UEFI.

    Spec:

    - current: <http://uefi.org/specifications>
    - old: <http://www.uefi.org/acpi/specs>

-   APM <https://en.wikipedia.org/wiki/Advanced_Power_Management>

    <http://wiki.osdev.org/APM>

    Older and simpler.

    By Microsoft in 1995. Spec seems to be in RTF format...

See also: <http://wiki.osdev.org/Shutdown>

## Bibliography

-   <http://stackoverflow.com/questions/22054578/run-a-program-without-an-operating-system>

-   <https://github.com/programble/bare-metal-tetris> tested on Ubuntu 14.04. Just works.

    Has Multiboot and El Torito. Uses custom linker script.

    Almost entirely in C `-nostdlib`, with very few inline `asm` commands, and a small assembly entry point. So a good tutorial in how to do the bridge.

-   osdev.org is a major source for this.

    - <http://wiki.osdev.org/C%2B%2B_Bare_Bones>
    - <http://wiki.osdev.org/Text_UI>
    - <http://wiki.osdev.org/GUI>

-   <https://github.com/scanlime/metalkit> A more automated / general bare metal compilation system. Untested, but looks promising.

The following did not work on my machine out of the box:

- <https://github.com/apparentlymart/ToyOS>
- <https://github.com/rde1024/toyos>
