# UEFI

Successor for BIOS.

TODO get a hello world program working.

- http://www.rodsbooks.com/efi-programming/hello.html Best source so far: allowed me to compile the hello world! TODO: how to run it now on QEMU and real hardware?
- https://fedoraproject.org/wiki/Using_UEFI_with_QEMU
- https://wiki.ubuntu.com/UEFI/OVMF

Sources:

- https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface
- http://wiki.osdev.org/UEFI

Running without image gives the UEFI shell, and a Linux kernel image booted fine with it: http://unix.stackexchange.com/a/228053/32558 , so we just need to generate the image.

OVMF.fd IA32 r15214 downloaded from: https://sourceforge.net/projects/edk2/files/OVMF/OVMF-IA32-r15214.zip/download

Included in-source for convenience, even though it is ugly.

## Shell

UEFI gives you an interactive shell that lets you do things like choose an OS to load.

Looks a bit like GRUB, but this is standardized.

### exit

Exit the shell.

### fs0:

Enter a filesystem.

TODO: how to make it visible in the first place?
