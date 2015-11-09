# TODO

-   cache:

    - http://stackoverflow.com/questions/1756825/how-can-i-do-a-cpu-cache-flush
    - http://stackoverflow.com/questions/10989403/how-is-x86-instruction-cache-synchronized

    - wbinvd: write back from cache to memory, and invalidate all cache
    - invd: just invalidate, but don't write back
    - clflush: flush only selected cache lines

-   lidt, interrupts, IDTR:

    - https://en.wikipedia.org/wiki/Double_fault
    - https://en.wikipedia.org/wiki/Triple_fault

-   PIC example

-   paging

    Page fault:

    - http://stackoverflow.com/questions/5684365/what-causes-page-faults/5690636#5690636
    - http://stackoverflow.com/questions/15275059/whats-the-purpose-of-x86-cr0-wp-bit

    Dirty:

    - http://stackoverflow.com/questions/7924031/how-prompt-is-x86-at-setting-the-page-dirty-bit/7926931#7926931
    - http://stackoverflow.com/questions/21211942/x86-page-fault-description

-   64-bit

    http://stackoverflow.com/questions/22962251/how-to-enter-64-bit-mode-on-a-x86-64/22963701#22963701

-   Segment registers /segmentation and protected mode. Then try to answer all of: GDT

    Bunch of basic dupes:

    - answered: http://stackoverflow.com/questions/4119504/real-mode-memory-addressing-explanation
    - http://stackoverflow.com/questions/3819699/what-does-ds40207a-mean-in-assembly

    In actual OSes:

    - http://stackoverflow.com/questions/22446104/do-the-x86-segment-registers-have-special-meaning-usage-on-modern-cpus-and-oses?lq=1
    - http://reverseengineering.stackexchange.com/questions/2006/how-are-the-segment-registers-fs-gs-cs-ss-ds-es-used-in-linux
    - http://stackoverflow.com/questions/14480579/when-does-segment-registers-change
    - http://stackoverflow.com/questions/12760109/how-is-the-x86-data-segment-used-in-real-operating-systems-and-processes
    - http://stackoverflow.com/questions/6611346/amd64-fs-gs-registers-in-linux

    Segfault:

    - http://stackoverflow.com/questions/6950549/segmentation-fault-vs-page-fault
    - http://stackoverflow.com/questions/10948930/page-fault-and-segmentation-fault
    - http://stackoverflow.com/questions/10948930/page-fault-and-segmentation-fault

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

    Local descriptor table:

    - http://stackoverflow.com/questions/14299893/any-tutorials-on-how-to-set-up-a-ldt?rq=1

-   WRMSR https://en.wikipedia.org/wiki/Model-specific_register http://x86.renejeschke.de/html/file_module_x86_id_326.html

-   BIOS

    - pages

-   ACPI

-   play with hardware

    -   set a pixel on screen in protected mode http://stackoverflow.com/questions/14419088/assembly-draw-a-pixel-on-the-screen-in-protected-mode
    -   USB: http://stackoverflow.com/questions/11810736/usb-control-in-x86-real-mode?rq=1
    -   networking
    -   GPU...
    -   how to setup arbitrary hardware: ports and IRQs http://stackoverflow.com/questions/773199/how-do-i-identify-device-specific-interrupts-on-x86
    -   PCI: 0xCF8 <http://stackoverflow.com/questions/15574717/pci-device-check-in-assembly-language>

-   POST https://en.wikipedia.org/wiki/Power-on_self-test

-   exemplify all CPU modes

    -   http://stackoverflow.com/questions/20848412/modes-of-intel-64-cpu

-   https://en.wikipedia.org/wiki/Task_state_segment

    Not used by Linux: <http://stackoverflow.com/questions/2711044/why-doesnt-linux-use-the-hardware-context-switch-via-the-tss>

-   keyboard through interrupt (high level BIOS int 16 that waits for input done)

    - keyboard protected mode: http://stackoverflow.com/questions/219120/x86-assembly-protected-mode-keyboard-access
    - oszur does it with the i8042: http://stackoverflow.com/questions/22744624/keyboard-interrupt-handler-for-own-kernel-c
    - https://github.com/arjun024/mkeykernel contains a small example that is easy to dissect
    - happens on IRQ 1 as mentioned at: https://en.wikipedia.org/wiki/Interrupt_request_%28PC_architecture%29#Master_PIC

-   mouse

    Does not seem to be an easy BIOS way:

    -   DOS question: http://stackoverflow.com/questions/23043732/accessing-the-mouse-via-assembly-x86

    -   http://stackoverflow.com/questions/5754233/int-33h-doesnt-work

    -   Linux questions:

        - http://stackoverflow.com/questions/15322892/linux-usb-mouse-drivers
        - http://stackoverflow.com/questions/25175960/which-drivers-are-used-by-usb-mouse-in-linux-kernel

-   control registers CRX

    - why CR1 does not exist, but CR8 does http://www.pagetable.com/?p=364

-   HPET https://en.wikipedia.org/wiki/High_Precision_Event_Timer

-   BIOS memory detect:

    http://stackoverflow.com/questions/21820814/what-happens-with-a-processor-when-it-tries-to-access-a-nonexistent-physical-add

-   `40h:6Ch` a bios timer incremented at 18.2 Hz: `
