# About

There are a few tutorials that explain how to make an operating system and give examples of increasing complexity with more and more functionality added.

This is not one of them.

The goal of this repository is to use the minimal setup possible to be able to observe *a single* low-level programming concept for each minimal operating system we create.

This is not meant provide a template from which you can write a real OS, but instead to illustrate how those low level concepts work, so that you can use that knowledge to implement operating systems or drivers.

Minimal examples are useful because it is easier to observe the requirements for a given concept to be observable.

Another advantage is that it is easier to DRY up minimal examples (here done simply through `#include` and macros), which is much harder on progressive OS template tutorials, which tend to repeat big chunks of code between the examples.

Using C or not is a hard choice. It does make it much easier to express higher level ideas, and gives portability. But in the end, it increases the complexity that one has to understand, so we've stayed away from it.

Always try to look into to Linux kernel to find where those CPU capabilities are used on a "real" OS.

## Pre-requisites

OS dev is one of the most insanely hard programming tasks a person can undertake, and will push your knowledge of several domains to the limit.

Knowing the following will help a lot:

- userland x86 assembly: https://github.com/cirosantilli/assembly-cheat
- compilation, linking and ELF format basics
- GDB debugging

While it is possible to learn those topics as you go along, and it is almost certain that you will end up learning more about them, we will not explain them here in detail.
