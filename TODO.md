# TODO

-   exemplify all CPU modes

    -   move to 32 bit mode. Answer http://stackoverflow.com/questions/7130726/writing-a-hello-world-kernel
    -   http://stackoverflow.com/questions/20848412/modes-of-intel-64-cpu

- cache: wbinvd

-   inb outb

    Answer with bare metal Tetris

    - http://stackoverflow.com/questions/8365746/what-does-outb-in-att-asm-mean
    - http://stackoverflow.com/questions/3215878/what-are-in-out-instructions-in-x86-used-for DUPE
    - http://stackoverflow.com/questions/3194139/x86-memory-and-i-o-map DUPE
    - http://stackoverflow.com/questions/14848645/what-does-this-code-do-in-intel-assembly-language/14848821#14848821
    - http://stackoverflow.com/questions/8894241/real-mode-x86-asm-how-are-the-basics-done?rq=1
    - http://wiki.osdev.org/Text_UI

    Port 0x80 on Linux kenrnel:

    - https://github.com/torvalds/linux/blob/v4.2/arch/x86/boot/boot.h#L78
    - http://stackoverflow.com/questions/6793899/what-does-the-0x80-port-address-connects

- lidt, interrupts, IDTR:

    - http://stackoverflow.com/questions/3392831/what-happens-in-an-interrupt-service-routine
    - http://stackoverflow.com/questions/1817577/what-does-int-0x80-mean-in-assembly-code
    - http://stackoverflow.com/questions/12464329/is-it-possible-to-make-a-custom-interrupt-in-assembly
    - https://en.wikipedia.org/wiki/Double_fault
    - https://en.wikipedia.org/wiki/Triple_fault

- paging

- WRMSR https://en.wikipedia.org/wiki/Model-specific_register http://x86.renejeschke.de/html/file_module_x86_id_326.html

-   Segment registers /segmentation and protected mode. Then try to answer all of:

      http://stackoverflow.com/questions/18736663/what-does-the-colon-mean-in-x86-assembly-gas-syntax-as-in-dsbx
    - http://reverseengineering.stackexchange.com/questions/2006/how-are-the-segment-registers-fs-gs-cs-ss-ds-es-used-in-linux
    - http://stackoverflow.com/questions/10810203/what-is-the-fs-gs-register-intended-for
    - http://stackoverflow.com/questions/12760109/data-segment-in-x86-programs
    - http://stackoverflow.com/questions/14480579/when-does-segment-registers-change
    - http://stackoverflow.com/questions/14661916/gdt-segmented-memory
    - http://stackoverflow.com/questions/15335003/x86-protected-mode-segment-registers-purpose
    - http://stackoverflow.com/questions/17210620/assembler-calculating-a-memory-address-with-register-base?lq=1
    - http://stackoverflow.com/questions/18247106/implementing-gdt-with-basic-kernel
    - http://stackoverflow.com/questions/20717890/how-to-interpret-gs0x14?lq=1
    - http://stackoverflow.com/questions/22446104/do-the-x86-segment-registers-have-special-meaning-usage-on-modern-cpus-and-oses?lq=1
    - http://stackoverflow.com/questions/22962251/how-to-enter-64-bit-mode-on-a-x86-64/22963701#22963701
    - http://stackoverflow.com/questions/26058665/fs-register-in-assembly-code?lq=1
    - http://stackoverflow.com/questions/3819699/what-does-ds40207a-mean-in-assembly
    - http://stackoverflow.com/questions/4903906/assembly-using-the-data-segment-register-ds answer with minimal example and mention QEMU vs real hardwre http://wiki.osdev.org/Segmentation
    - http://stackoverflow.com/questions/518261/meaning-of-x86-assembler-instruction?lq=1
    - http://stackoverflow.com/questions/5364270/concept-of-mov-ax-cs-and-mov-ds-ax?lq=1
    - http://stackoverflow.com/questions/6611346/amd64-fs-gs-registers-in-linux
    - http://stackoverflow.com/questions/7844963/how-to-interpret-segment-register-accesses-on-x86-64?lq=1
    - http://stackoverflow.com/questions/9172837/idt-without-gdt-using-grub
    - http://stackoverflow.com/questions/9249315/what-is-gs-in-assembly?rq=1
    - http://stackoverflow.com/questions/928082/why-does-the-mov-instruction-have-to-be-used-this-way?lq=1

    64-bit:

    - http://stackoverflow.com/questions/22962251/how-to-enter-64-bit-mode-on-a-x86-64/22963701#22963701
    - http://stackoverflow.com/questions/21165678/why-64-bit-mode-long-mode-doesnt-use-segment-registers
    - http://stackoverflow.com/questions/19502868/meaning-of-cs-and-ss-registers-on-x86-64-linux-in-userland
    - http://stackoverflow.com/questions/7844963/how-to-interpret-segment-register-accesses-on-x86-64

    lgdt:

    - http://stackoverflow.com/questions/21128311/the-physical-address-of-global-descriptor-table
    - http://stackoverflow.com/questions/7415515/problem-accessing-control-registers-cr0-cr2-cr3
    - http://stackoverflow.com/questions/10671147/how-do-x86-page-tables-work?rq=1
    - http://stackoverflow.com/questions/14354626/how-to-create-two-separate-segments-in-global-descriptor-table
    - http://stackoverflow.com/questions/14812160/near-and-far-jmps

-   timer, IPT

-   BIOS

    - pages

-   ACPI

-   multithreading:

    http://stackoverflow.com/questions/7308391/how-is-concurrency-done-in-intel-x86-assembly || http://stackoverflow.com/questions/980999/what-does-multicore-assembly-language-look-like || http://stackoverflow.com/questions/714905/threads-in-x86-assembler-using-the-gnu-assember-as || https://github.com/cirosantilli/oszur11-operating-system-examples/tree/1af6451852887fac3d7206d4d09714c181c81d1e/Chapter_07_Threads

-   play with hardware

    -   keyboard through interrupt (high level BIOS int 16 that waits for input done)
        - keyboard protected mode: http://stackoverflow.com/questions/219120/x86-assembly-protected-mode-keyboard-access
    -   set a pixel on screen in protected mode http://stackoverflow.com/questions/14419088/assembly-draw-a-pixel-on-the-screen-in-protected-mode
    -   USB
    -   networking
    -   GPU...

-   POST https://en.wikipedia.org/wiki/Power-on_self-test

-   2 stage two stage boot: load another part from the disk

    - http://stackoverflow.com/a/28645943/895245 contains:

            [bits 16]
            [org 0x7c00]
            mov ax, 0201h
            mov cx, 0002h
            mov dh, 0
            mov bx, 0
            mov es, bx
            mov bx, 2000h
            int 13h
            jmp 0:2000h

            [SECTION signature start=0x7dfe]
            dw 0AA55h
