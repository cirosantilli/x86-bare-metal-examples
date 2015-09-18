SECTIONS
{
    /*
    We could also pass the -Ttext 0x7C00 to as instead of doing this.

    If your program does not have any memory accesses, you can omit this.
    */
    . = 0x7c00;
    .text :
    {
        *(*)
        /*
        Magic bytes. 0x1FE == 510.

        We could add this on each Gas file.
        */
        . = 0x1FE;
        SHORT(0xAA55)
    }
}
