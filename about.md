# About

There are a few tutorials that explain how to make an operating system and give examples of increasing complexity with more and more functionality added.

This is not one of them.

The goal of this repository is to use the minimal setup possible to be able to observe *a single* low-level programming concept for each minimal operating system we create.

This is not meant provide a template from which you can write a real OS, but instead to illustrate how those low level concepts work, so that you can use that knowledge to implement operating systems or drivers.

Minimal examples are useful because it is easier to observe the requirements for a given concept to be observable.

Another advantage is that it is easier to DRY up minimal examples (here done simply through `#include` and macros), which is much harder on progressive OS template tutorials, which tend to repeat big chunks of code between the examples.
