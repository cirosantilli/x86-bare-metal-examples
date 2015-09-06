SECTIONS
{
    /* We could also pass the -Ttext 0x7C00 to as instead of doing this. */
    . = 0x7c00;
    .text :
    {
        *(.*)
        /*
        Magic bytes. 0x1FE == 510.

        We could add this on each Gas file.

        TODO make them work here. Mentioned at: http://stackoverflow.com/a/9604338/895245

        Another interesting example shows AT: http://dc0d32.blogspot.fr/2010/06/real-mode-in-c-with-gcc-writing.html
        */
        /*
        . = 0x1FE;
        SHORT(0xAA55);
        */
    }
}
