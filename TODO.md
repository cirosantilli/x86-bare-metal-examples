# TODO

-   Segment registers on protected mode.

    - http://stackoverflow.com/questions/4903906/assembly-using-the-data-segment-register-ds answer with minimal example and mention QEMU vs real hardwre http://wiki.osdev.org/Segmentation
    - http://stackoverflow.com/questions/3819699/what-does-ds40207a-mean-in-assembly
    - http://stackoverflow.com/questions/5364270/concept-of-mov-ax-cs-and-mov-ds-ax?lq=1
    - http://stackoverflow.com/questions/518261/meaning-of-x86-assembler-instruction?lq=1
    - http://reverseengineering.stackexchange.com/questions/2006/how-are-the-segment-registers-fs-gs-cs-ss-ds-es-used-in-linux

-   move to 32 bit mode. Answer http://stackoverflow.com/questions/7130726/writing-a-hello-world-kernel

-   load a stage 2 from disk into memory

    - http://stackoverflow.com/questions/7716427/loading-2nd-stage-of-bootloader-and-starting-it
    - http://stackoverflow.com/questions/2065370/how-to-load-second-stage-boot-loader-from-first-stage

-   interrupt

-   timer

-   BIOS

    - pages

-   ACPI

    -   reboot computer. Would put QEMU into an infinite reboot loop. Awesome.

-   multithreading: http://stackoverflow.com/questions/7308391/how-is-concurrency-done-in-intel-x86-assembly || http://stackoverflow.com/questions/980999/what-does-multicore-assembly-language-look-like || http://stackoverflow.com/questions/714905/threads-in-x86-assembler-using-the-gnu-assember-as || https://github.com/cirosantilli/oszur11-operating-system-examples/tree/1af6451852887fac3d7206d4d09714c181c81d1e/Chapter_07_Threads

-   transition to protected mode

    - test the paging circuit

-   play with hardware

    -   set a pixel on screen in protected mode http://stackoverflow.com/questions/14419088/assembly-draw-a-pixel-on-the-screen-in-protected-mode
    -   USB
    -   networking
    -   GPU...

-   outb inb instructions

-   POST https://en.wikipedia.org/wiki/Power-on_self-test
