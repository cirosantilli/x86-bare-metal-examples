# Getting started

Ubuntu:

    ./configure

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

You can also try out the big image on QEMU for fun with:

    qemu-system-i386 -hda big.img

You will also want to change the boot order to put the USB first from the F12 BIOS menu. This way you don't have to hit F12 like a madman every time.

TODO: boot sectors that load STAGE2 are not working with the big image chainloader. TODO why?

## Docker

If you don't have an Ubuntu box, this is an easy alternative:

    sudo docker run -it --net=host ubuntu:14.04 bash

Then proceed normally in the guest: install packages, and build:

    apt-get update
    apt-get install git
    git clone https://github.com/cirosantilli/x86-bare-metal-examples
    cd x86-bare-metal-examples
    ./configure
    make

To overcome the lack of GUI, we can use QEMU's VNC implementation instead of the default SDL, which is visible on the host due to `--net=host`:

    qemu-system-i386 -hda main.img -vnc :0

and then on host:

    sudo apt-get install vinagre
    vinagre localhost:5900
