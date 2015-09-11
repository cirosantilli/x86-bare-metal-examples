global loader
global stack_ptr

extern main

MODULEALIGN equ 1<<0
MEMINFO equ 1<<1
FLAGS equ MODULEALIGN | MEMINFO
MAGIC equ 0x1BADB002
CHECKSUM equ -(MAGIC + FLAGS)

section .mbheader
align 4
MultiBootHeader:
  dd MAGIC
  dd FLAGS
  dd CHECKSUM

section .text

STACKSIZE equ 0x4000

loader:
  mov esp, stack+STACKSIZE
  push eax
  push ebx

  call main

  cli

hang:
  hlt
  jmp hang

section .bss
align 4
stack:
  resb STACKSIZE
stack_ptr:
