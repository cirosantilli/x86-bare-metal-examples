# x86 Bare Metal Examples

Hello world programs that run without an operating system.

1.  Examples
    1.  [printf](printf/)
    1.  [min](min.S)
    1.  [No ld script](no-ld-script/)
    1.  [NASM](nasm/)
    1.  [BIOS one char](bios_one_char.S)
    1.  [BIOS hello world](bios_hello_world.S)
    1.  [APM shutdown](apm_shutdown.S)
    1.  [APM shutdown 2](apm_shutdown2.S)
    1.  [Multiboot](multiboot/)
    1.  TODO not working
        1. [UEFI](uefi/)
    1.  Misc
        1.  [hajji](hajji/)
1.  Theory
    1.  [Formats](formats.md)
        1.  [MBR](mbr.md)
    1.  [IO](io.md)
        1.  [BIOS](bios.md)
    1.  [Bibliography](bibliography.md)
1.  [TODO](TODO.md)

## Getting started

    sudo apt-get install build-essential gnu-efi qemu nasm xorriso

Run the default program on QEMU:

    make run

Run a given program:

    make run RUN=min
    make run RUN=bios_one_char

Tested on Ubuntu 14.04 AMD64.

To run on real hardware, insert an USB, determine its device (`/dev/sdX`) with:

    sudo lsblk
    sudo fdisk -l

Pick the `.img` file that you wan to run and:

    sudo dd if=bios_hello_world.img of=/dev/sdX

Then:

- insert the USB in a computer
- during boot, hit some special hardware dependant key, usually F12, Esc
- choose to boot from the USB

Tested on: ThinkPad T400.
