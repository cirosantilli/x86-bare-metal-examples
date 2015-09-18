# Symlinks

This directory relies on the following symlinks to make directory structure modifiable in the future:

1.  [mbrs](mbrs): directory that contains the Makefile for `bios_hello_world.img` and other MBRs

1.  [bios_hello_world.img.sym](bios_hello_world.img.sym): boot sector that says hello world with BIOS

    The `.sym` extension must be used because otherwise this symlink would be gitignored.
