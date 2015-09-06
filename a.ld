SECTIONS
{
    /* We could also pass the -Ttext 0x7C00 to as instead of doing this. */
    . = 0x7c00;
    bootsec :
    {
        *(.text)
    }
}
