# BIOS

<https://en.wikipedia.org/wiki/BIOS>

<http://wiki.osdev.org/BIOS>

<http://wiki.osdev.org/Real_Mode>

Can only be used in real mode.

## Documentation

Does any documentation or portability exist??

<http://www.ctyme.com/intr/int.htm> Ralf Brown's Interrupt List. Everyone says that this is the ultimate unofficial compilation.

<https://en.wikipedia.org/wiki/INT_10H> good quick summary

<http://www.scs.stanford.edu/nyu/04fa/lab/specsbbs101.pdf> says little about interrupts, I don't understand it's scope.

## Video mode

There are several video modes.

Modes determine what interrupt functions can be used.

There are 2 main types of modes:

- text, where we operate character-wise
- video, operate byte-wise

Modes can be set with `int 0x10` and `AH = 0x00`, and get with `AH = 0x0F`

The most common modes seem to be:

- 0x01: 40x25 Text, 16 colors, 8 pages
- 0x03: 80x25 Text, 16 colors, 8 pages
- 0x13: 320x200 Graphics, 256 colors, 1 page

You can add 128 to the modes to avoid clearing the screen.

Taken from: <https://courses.engr.illinois.edu/ece390/books/labmanual/graphics-int10h.html>

A larger list: <http://www.columbia.edu/~em36/wpdos/videomodes.txt>

## Colors

## Text properties

<https://en.wikipedia.org/wiki/BIOS_color_attributes>

## Get BIOS information

## SMBIOS

## dmidecode

<http://stackoverflow.com/questions/20604644/how-to-check-the-bios-version-or-name-in-linux-through-command-prompt>

<https://en.wikipedia.org/wiki/System_Management_BIOS>

Standardized by: <https://en.wikipedia.org/wiki/Distributed_Management_Task_Force>

TODO: how is it obtained at the low level?

## UEFI

<https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface>

<https://github.com/tqh/efi-example>

## SeaBIOS

<http://www.seabios.org/SeaBIOS>

Open source x86 BIOS implementation.

Default BIOS for QEMU and KVM.
