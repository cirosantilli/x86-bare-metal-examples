SECTIONS
{
    /* We could also pass the -Ttext 0x7C00 to as instead of doing this.
     * If your program does not have any memory accesses, you can omit this.
     */
    . = 0x7c00;
    .text :
    {
        __start = .;

        /* We are going to stuff everything
         * into a text segment for now, including data.
         * Who cares? Other segments only exist to appease C compilers.
         */
        *(.text)

        /* Magic bytes. 0x1FE == 510.
         *
         * We could add this on each Gas file separately with `.word`,
         * but this is the perfect place to DRY that out.
         */
        . = 0x1FE;
        SHORT(0xAA55)

        /* This is only needed if we are going to use a 2 stage boot process,
         * e.g. by reading more disk than the default 512 bytes with BIOS `int 0x13`.
         */
        *(.stage2)

        /* Number of sectors in stage 2. Used by the `int 13` to load it from disk.
         *
         * The value gets put into memory as the very last thing
         * in the `.stage` section if it exists.
         *
         * We must put it *before* the final `. = ALIGN(512)`,
         * or else it would fall out of the loaded memory.
         *
         * This must be absolute, or else it would get converted
         * to the actual address relative to this section (7c00 + ...)
         * and linking would fail with "Relocation truncated to fit"
         * because we are trying to put that into al for the int 13.
         */
        __stage2_nsectors = ABSOLUTE((. - __start) / 512);

        /* Ensure that the generated image is a multiple of 512 bytes long. */
        . = ALIGN(512);
        __end = .;
        __end_align_4k = ALIGN(4k);
    }
}
