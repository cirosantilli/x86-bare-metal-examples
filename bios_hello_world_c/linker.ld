ENTRY(mystart)
SECTIONS
{
  .text : {
    entry.o(.text)
    *(.text)
    *(.rodata)
    *(.data)
    /**(.eh_frame)*/
    . = 0x1FE;
    SHORT(0xAA55)
  }
  /* Reserve 16 MiB of stack. */
  __stack_bottom = .;
  . = . + 0x1000000;
  __stack_top = .;
}
