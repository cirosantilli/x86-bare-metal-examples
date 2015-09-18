# chainloader

Takes another boot sector as argument.

This simply forwards the boot sector to another bootloader.

This is what you need to boot unsupported systems like Windows: just point to their partition and let them do the job.

This example uses a file, but the most common way to use it is with:

    chainloader +1

which uses the first sector of some partition instead of a file.
