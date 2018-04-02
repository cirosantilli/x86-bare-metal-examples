# Getting started

Tested on Ubuntu 14.04 AMD64:

    sudo apt-get install bochs bochs-sdl build-essential gdb gnu-efi qemu nasm xorriso

Make all operating systems:

    make

Each `.S` file on the top-level is an operating system!

## Emulator

Run the default OS on QEMU:

    make run

Run a given OS:

    make run RUN=min
    make run RUN=bios_one_char

Use Bochs instead of QEMU:

    make bochs RUN=min

## Real hardware

Insert an USB, determine its device (`/dev/sdX`) with:

    sudo lsblk
    sudo fdisk -l

Pick the `.img` file that you wan to run and:

    sudo dd if=bios_hello_world.img of=/dev/sdX

Then:

- insert the USB in a computer
- during boot, hit some special hardware dependant key, usually F12, Esc
- choose to boot from the USB

When you are done, just hit the power button to shutdown.

Tested on: ThinkPad T400.

### Big image

Create a `big.img` that contains all examples that can be booted from GRUB:

    make big.img

Now if you do:

    sudo dd if=big.img of=/dev/sdX

you can test several examples with a single USB burn, which is much faster.

You will also want to change the boot order to put the USB first from the F12 BIOS menu. This way you don't have to hit F12 like a madman every time.

TODO: boot sectors that load STAGE2 are not working with the big image chainloader. TODO why?
