# Hello world multiboot C

Originally from: <http://wiki.osdev.org/Bare_Bones>, should be a reasonable way to start a serious OS.

QEMU opens the boot menu, but if I select `main` it fails with: "no multiboot header found". Things which might be wrong:

- not using cross compiler
- generated `.bin` does not contain the multiboot section. TODO why?

Related questions:

- <http://stackoverflow.com/questions/14311761/simple-kernel-wont-boot-in-grub>
- <http://stackoverflow.com/questions/17539464/grub-2-not-detecting-multiboot-header-in-kernel>
- <http://stackoverflow.com/questions/25517545/error-no-multiboot-header-found>

---

A hello world, with multiboot and a C interface.

The multiboot interface is prepared in GAS assembly.

Generates a bootable disk image by using `grub-mkrescue` on the multiboot binary.
