ENTRY(mystart)
SECTIONS
{
  . = 0x7c00;
  .text : {
    entry.o(.text)
    *(.text)
    *(.data)
    *(.rodata)
    __bss_start = .;
    *(.bss)
    __bss_end = .;
  }
  /* https://stackoverflow.com/questions/53584666/why-does-gnu-ld-include-a-section-that-does-not-appear-in-the-linker-script */
  .sig : AT(ADDR(.text) + 512 - 2)
  {
      SHORT(0xaa55);
  }
  /DISCARD/ : {
    *(.eh_frame)
  }
  __stack_bottom = .;
  . = . + 0x1000;
  __stack_top = .;
}
