# About

## System vs userland

The CPU / system API is divided into two parts:

-   userland: things that applications can do freely on top of an OS. Basically only run simple instructions like: `add`, `jmp`, `cmp`, `mov`, or call some kernel handler (e.g. `int`).

    So the only way to learn that is to create a bunch of OSes!

-   system: things that OSes can do, but they don't let applications do to prevent one application destroying / spying on another (sandboxing).

    E.g.:

    -   some instructions, e.g. `in`, `out`

    -   memory without paging / segmentation.

        This in turn allows writing to magic hardware defined addresses that control other hardwares, like the interrupt handler (PIT) and the real time clock (RTC)

This repository covers only system level programming.

## One minimal concept per OS

There are a few tutorials that explain how to make an operating system and give examples of increasing complexity with more and more functionality added.

This is not one of them.

The goal of this repository is to use the minimal setup possible to be able to observe *a single* low-level programming concept for each minimal operating system we create.

This is not meant provide a template from which you can write a real OS, but instead to illustrate how those low-level concepts work in isolation, so that you can use that knowledge to implement operating systems or drivers.

Minimal examples are useful because it is easier to observe the requirements for a given concept to be observable.

Another advantage is that it is easier to DRY up minimal examples (here done simply through `#include` and macros), which is much harder on progressive OS template tutorials, which tend to repeat big chunks of code between the examples.

## To C or not to C

Using C or not is a hard choice.

It does make it much easier to express higher level ideas, and gives portability.

But in the end, it increases the complexity that one has to understand, so we've stayed away from it.

## Linux is open source

Always try looking into the Linux kernel to find how those CPU capabilities are used in a "real" OS.

## Pre-requisites

OS dev is one of the most insanely hard programming tasks a person can undertake, and will push your knowledge of several domains to the limit.

Knowing the following will help a lot:

- userland x86 assembly: https://github.com/cirosantilli/assembly-cheat
- compilation, linking and ELF format basics
- GDB debugging

While it is possible to learn those topics as you go along, and it is almost certain that you will end up learning more about them, we will not explain them here in detail.
