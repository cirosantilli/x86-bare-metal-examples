# TODO

-   exemplify all CPU modes

    -   move to 32 bit mode. Answer http://stackoverflow.com/questions/7130726/writing-a-hello-world-kernel
    -   http://stackoverflow.com/questions/20848412/modes-of-intel-64-cpu

-   instructions

    - cache: wbinvd
    - outb inb
    - lgdtl, paging http://stackoverflow.com/questions/21128311/the-physical-address-of-global-descriptor-table http://stackoverflow.com/questions/7415515/problem-accessing-control-registers-cr0-cr2-cr3
    - lidtl, interrupts, IDTR
        - https://en.wikipedia.org/wiki/Double_fault
        - https://en.wikipedia.org/wiki/Triple_fault
        - http://stackoverflow.com/questions/1817577/what-does-int-0x80-mean-in-assembly-code
        - http://stackoverflow.com/questions/12464329/is-it-possible-to-make-a-custom-interrupt-in-assembly
    - WRMSR https://en.wikipedia.org/wiki/Model-specific_register http://x86.renejeschke.de/html/file_module_x86_id_326.html

-   Segment registers on protected mode. Then try to answer all of:

    - http://reverseengineering.stackexchange.com/questions/2006/how-are-the-segment-registers-fs-gs-cs-ss-ds-es-used-in-linux
    - http://stackoverflow.com/questions/10810203/what-is-the-fs-gs-register-intended-for
    - http://stackoverflow.com/questions/12760109/data-segment-in-x86-programs
    - http://stackoverflow.com/questions/14480579/when-does-segment-registers-change
    - http://stackoverflow.com/questions/15335003/x86-protected-mode-segment-registers-purpose
    - http://stackoverflow.com/questions/17210620/assembler-calculating-a-memory-address-with-register-base?lq=1
      http://stackoverflow.com/questions/18736663/what-does-the-colon-mean-in-x86-assembly-gas-syntax-as-in-dsbx
    - http://stackoverflow.com/questions/20717890/how-to-interpret-gs0x14?lq=1
    - http://stackoverflow.com/questions/22446104/do-the-x86-segment-registers-have-special-meaning-usage-on-modern-cpus-and-oses?lq=1
    - http://stackoverflow.com/questions/26058665/fs-register-in-assembly-code?lq=1
    - http://stackoverflow.com/questions/3819699/what-does-ds40207a-mean-in-assembly
    - http://stackoverflow.com/questions/4903906/assembly-using-the-data-segment-register-ds answer with minimal example and mention QEMU vs real hardwre http://wiki.osdev.org/Segmentation
    - http://stackoverflow.com/questions/518261/meaning-of-x86-assembler-instruction?lq=1
    - http://stackoverflow.com/questions/5364270/concept-of-mov-ax-cs-and-mov-ds-ax?lq=1
    - http://stackoverflow.com/questions/6611346/amd64-fs-gs-registers-in-linux
    - http://stackoverflow.com/questions/7844963/how-to-interpret-segment-register-accesses-on-x86-64?lq=1
    - http://stackoverflow.com/questions/928082/why-does-the-mov-instruction-have-to-be-used-this-way?lq=1

    64-bit:

    - http://stackoverflow.com/questions/21165678/why-64-bit-mode-long-mode-doesnt-use-segment-registers
    - http://stackoverflow.com/questions/19502868/meaning-of-cs-and-ss-registers-on-x86-64-linux-in-userland
    - http://stackoverflow.com/questions/7844963/how-to-interpret-segment-register-accesses-on-x86-64

-   load a stage 2 from disk into memory

    - http://stackoverflow.com/questions/7716427/loading-2nd-stage-of-bootloader-and-starting-it
    - http://stackoverflow.com/questions/2065370/how-to-load-second-stage-boot-loader-from-first-stage

-   interrupt

-   timer

-   BIOS

    - pages

-   ACPI

-   multithreading: http://stackoverflow.com/questions/7308391/how-is-concurrency-done-in-intel-x86-assembly || http://stackoverflow.com/questions/980999/what-does-multicore-assembly-language-look-like || http://stackoverflow.com/questions/714905/threads-in-x86-assembler-using-the-gnu-assember-as || https://github.com/cirosantilli/oszur11-operating-system-examples/tree/1af6451852887fac3d7206d4d09714c181c81d1e/Chapter_07_Threads

-   play with hardware

    -   keyboard through interrupt (high level int 16 bios done)
        - keyboard protected mode: http://stackoverflow.com/questions/219120/x86-assembly-protected-mode-keyboard-access
    -   set a pixel on screen in protected mode http://stackoverflow.com/questions/14419088/assembly-draw-a-pixel-on-the-screen-in-protected-mode
    -   USB
    -   networking
    -   GPU...

-   POST https://en.wikipedia.org/wiki/Power-on_self-test
