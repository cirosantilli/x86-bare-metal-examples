SECTIONS
{
    /*
    We could also pass the -Ttext 0x7C00 to as instead of doing this.

    If your program does not have any memory accesses, you can omit this.
    */
    . = 0x7c00;
    .text :
    {
        /*
        We are going to stuff everything
        into a text segment for now, including data.
        Who cares? Other segments only exist to appease C compilers.
         */
        *(.text)

        /*
        Magic bytes. 0x1FE == 510.

        We could add this on each Gas file separately with `.word`,
        but this is the perfect place to DRY that out.
        */
        . = 0x1FE;
        SHORT(0xAA55)

        /*
        This is only needed if we are going to use a 2 stage boot process,
        e.g. by reading more disk than the default 512 bytes with BIOS `int 0x13`.
         */
        *(.stage2)
    }
}

/*
The linux kernel 4.2 uses linker scripts like:

- https://github.com/torvalds/linux/blob/v4.2/arch/x86/boot/setup.ld

The kernel also uses the `.lds` extension for its scripts.
*/
