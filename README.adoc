= x86 Bare Metal Examples
:idprefix:
:idseparator: -
:sectanchors:
:sectlinks:
:sectnumlevels: 6
:sectnums:
:toc: macro
:toclevels: 6
:toc-title:

Dozens of minimal operating systems to learn x86 system programming. Tested on Ubuntu 18.04 host in QEMU 2.11 and <<test-hardware,real hardware>>. Userland cheat at: https://github.com/cirosantilli/linux-kernel-module-cheat#userland-assembly ARM baremetal setup at: https://github.com/cirosantilli/linux-kernel-module-cheat#baremetal-setup

:logo: logo.jpg
link:{logo}[image:{logo}[]]

toc::[]

== China

Before <<getting-started>>, read this important pre-requisite: https://github.com/cirosantilli/china-dictatorship

Because human rights is more important than profit and technology.

image::https://raw.githubusercontent.com/cirosantilli/china-dictatorship-media/master/Hao_Haidong_kick.jpg[width=600]

image::https://raw.githubusercontent.com/cirosantilli/china-dictatorship-media/master/Xi_sadomasochist.jpg[width=600]

== Getting started

First read this introduction: https://stackoverflow.com/questions/22054578/how-to-run-a-program-without-an-operating-system/32483545#32483545

Then on Ubuntu:

....
./configure
make
....

Each `.S` file on the top-level is an operating system! It gets compiled to a corresponding `.img` file.

Run the default OS on QEMU:

....
./run
....

Run a given OS:

....
./run bios_hello_world
./run bios_putc
....

Examples described at:

* <<bios-examples>>
* <<bios-hello-world>>

Extensions are ignored for perfect tab completion, so all the following are equivalent:

....
./run min
./run min.
./run min.S
./run min.img
....

Use Bochs instead of QEMU:

....
./run bios_hello_world bochs
....

Then on the terminal start the simulation with:

....
c
....

To quit Bochs either:

* press the poweroff button inside its GUI
* Ctrl + C on terminal and the type `quit` and hit enter

TODO: automate this step.

Bibliography: https://stackoverflow.com/questions/6142925/how-can-i-use-bochs-to-run-assembly-code/32871939#32871939

=== Getting started with real hardware

Insert an USB, determine its device (`/dev/sdX`) with:

....
sudo lsblk
sudo fdisk -l
....

Pick the `.img` file that you wan to run and:

....
sudo dd if=bios_hello_world.img of=/dev/sdX
....

Then:

* insert the USB in a computer
* during boot, hit some special hardware dependant key, usually F12, Esc
* choose to boot from the USB

When you are done, just hit the power button to shutdown.

For example, on my T430  I see the following.

After turning on, this is when I have to press Enter to enter the boot menu:

image::https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Lenovo_ThinkPad_T430_UEFI_BIOS_1.16_splash_screen.jpg/640px-Lenovo_ThinkPad_T430_UEFI_BIOS_1.16_splash_screen.jpg[]

Then, here I have to press F12 to select the USB as the boot device:

image::https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Lenovo_ThinkPad_T430_UEFI_BIOS_1.16_Startup_Interrupt_Menu.jpg/640px-Lenovo_ThinkPad_T430_UEFI_BIOS_1.16_Startup_Interrupt_Menu.jpg[]

From there, I can select the USB as the boot device like this:

image::https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Lenovo_ThinkPad_T430_UEFI_BIOS_1.16_Boot_Menu.jpg/640px-Lenovo_ThinkPad_T430_UEFI_BIOS_1.16_Boot_Menu.jpg[]

Alternatively, to change the boot order and choose the USB to have higher precedence so I don't have to manually select it every time, I would hit F1 on the "Startup Interrupt Menu" screen, and then navigate to:

image::https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Lenovo_ThinkPad_T430_UEFI_BIOS_1.16_boot_order_menu.jpg/640px-Lenovo_ThinkPad_T430_UEFI_BIOS_1.16_boot_order_menu.jpg[]

See also: <<test-hardware>>

==== Getting started with the big image

Create a `big.img` that contains all examples that can be booted from GRUB:

....
make big.img
....

Now if you do:

....
sudo dd if=big.img of=/dev/sdX
....

you can test several examples with a single USB burn, which is much faster.

You can also try out the big image on QEMU for fun with:

....
qemu-system-i386 -hda big.img
....

You will also want to change the boot order to put the USB first from the F12 BIOS menu. This way you don't have to hit F12 like a madman every time.

TODO: boot sectors that load STAGE2 are not working with the big image chainloader. TODO why?

=== Getting started with Docker

If you don't have an Ubuntu box, this is an easy alternative, for the first run:

....
sudo docker run --interactive --tty --name xbme --net=host ubuntu:18.04 bash
....

and the following runs:

....
sudo docker start xbme
sudo docker exec --interactive --tty xbme bash
sudo docker stop xbme
....

and to nuke the container later on:

....
# sudo docker rm xbme
....

Then proceed normally in the guest: install packages, and build:

....
apt-get update && \
apt-get install -y git && \
git clone https://github.com/cirosantilli/x86-bare-metal-examples && \
cd x86-bare-metal-examples && \
./configure -y && \
make
....

To overcome the lack of GUI, we can use QEMU's VNC implementation instead of the default SDL, which is visible on the host due to `--net=host`:

....
./run bios_hello_world run -vnc :0
....

and then on host:

....
sudo apt-get install vinagre
vinagre localhost:5900
....

TODO: get sound working from docker: <<pc-speaker>>: https://stackoverflow.com/questions/41083436/how-to-play-sound-in-a-docker-container

It should also be possible to run a GUI inside the container, but I haven't tested: https://stackoverflow.com/questions/40658095/how-to-open-ubuntu-gui-inside-a-docker-image/57636624#57636624

=== GDB step debug

To GDB step debug the program, run it with:

....
./run bios_hello_world debug
....

This will leave you at the very first instruction executed by our program, which is the beginning of our `BEGIN` macro.

Note however that this is not the very first instruction QEMU executes: that will actually be BIOS setup code that runs before our program itself.

You can then basically debug as you would a normal userland program, notably:

* I then highly recommend that you use https://github.com/cyrus-and/gdb-dashboard[GDB Dashboard] to see what is going on.
* `n` skips over macros
* `ni` steps within macros. But you will need to enable the printing of assembly code on GDB Dashboard to see where you are at

With this God-like GDB Dashboard setup, at 89cbe7be83f164927caebc9334bc42990e499cb1 I see a perfect program view such as:

....
 1 /* https://github.com/cirosantilli/x86-bare-metal-examples#bios-hello-world */
 2
 3 #include "common.h"
 4 BEGIN
 5     mov $msg, %si
 6     mov $0x0e, %ah
 7 loop:
 8     lodsb
 9     or %al, %al
10     jz halt
11     int $0x10
12     jmp loop
─── Assembly ────────────────────────────────────────────────────────────────────────────
0x00007c00 __start+0  cli
0x00007c01 __start+1  ljmp   $0xc031,$0x7c06
0x00007c08 __start+8  mov    %eax,%ds
0x00007c0a __start+10 mov    %eax,%es
0x00007c0c __start+12 mov    %eax,%fs
0x00007c0e __start+14 mov    %eax,%gs
0x00007c10 __start+16 mov    %eax,%ebp
0x00007c12 __start+18 mov    %eax,%ss
0x00007c14 __start+20 mov    %ebp,%esp
─── Registers ───────────────────────────────────────────────────────────────────────────
   eax 0x0000aa55    ecx 0x00000000    edx 0x00000080    ebx 0x00000000    esp 0x00006f04
   ebp 0x00000000    esi 0x00000000    edi 0x00000000    eip 0x00007c00 eflags [ IF ]    
    cs 0x00000000     ss 0x00000000     ds 0x00000000     es 0x00000000     fs 0x00000000
    gs 0x00000000
─── Stack ───────────────────────────────────────────────────────────────────────────────
[0] from 0x00007c00 in __start+0 at bios_hello_world.S:4
(no arguments)
─────────────────────────────────────────────────────────────────────────────────────────
>>>
....

Debug symbols are obtained by first linking ELF files, and then using `objcopy` on them to generate the final image. We then pass the ELF files with the debug information to GDB:  https://stackoverflow.com/questions/32955887/how-to-disassemble-16-bit-x86-boot-sector-code-in-gdb-with-x-i-pc-it-gets-tr/32960272#32960272

How to step over `int` calls: http://stackoverflow.com/questions/24491516/how-to-step-over-interrupt-calls-when-debugging-a-bootloader-bios-with-gdb-and-q

Single stepping until a given opcode can be helpful sometimes: https://stackoverflow.com/questions/14031930/break-on-instruction-with-specific-opcode-in-gdb/31249378#31249378

TODO: detect if we are on 16 or 32 bit automatically from control registers. Now I'm using 2 functions `16` and `32` to switch manually, but that sucks. The problem is that it's not possible to read them directly: http://stackoverflow.com/a/31340294/895245 If we had `cr0`, it would be easy to do with an `if cr0 & 1` inside a hook-stop.

TODO: Take segmentation offsets into account: http://stackoverflow.com/questions/10354063/how-to-use-a-logical-address-in-gdb

=== Build the documentation locally

....
make doc
xdg-open README.html
....

== Minimal examples

These are the first ones you should look at.

[[printf]]
=== Create a minimal image with printf

....
make -C printf run
....

Outcome: QEMU window opens up, prints a few boot messages, and hangs.

Our program itself does not print anything to the screen itself, just makes the CPU halt.

This example is generated with `printf` byte by byte: you can't get more minimal than this!

It basically consists of:

* byte 0: a `hlt` instruction
* bytes 1 through 509: zeroes, could be anything
* bytes 510 and 511: mandatory magic bytes `0xAA55`, which are required for BIOS to consider our disk.

=== Minimal GAS example

Minimal example that just halts the CPU without using our mini-library link:common.h[]:

....
./run min
....

Source: link:min.S[]

Outcome: QEMU window opens up, prints a few firmware messages, and hangs.

Here is an equivalent example using our mini-library:

....
./run template
....

Source: link:template.S[]

You can use that file as a quick template to start new tests.

==== Infinite loop

Go into an infinite loop instead of using `hlt`:

....
./run infinite_loop
....

Source: link:infinite_loop.S[].

The outcome if visibly the same, but TODO: it likely wastes more energy in real hardware?

==== Linker script

This hello world, and most of our OSes use the linker script: link:linker.ld[]

This critical file determines the memory layout of our assembly, take some time to read the comments in that file and familiarize yourself with it.

The Linux kernel also uses linker scripts to setup its image memory layout, see for example: https://github.com/torvalds/linux/blob/v4.2/arch/x86/boot/setup.ld

=== BIOS hello world

Print `hello world` after the firmware messages:

....
./run bios_hello_world
....

Source: link:bios_hello_world.S[]

==== C hello world

Same output as <<bios-hello-world>>, but written in C:

....
cd c_hello_world
./run
....

Source: link:c_hello_world/[]

But keep in mind the following limitations and difficulties:

* single stage, so still limited to 512 bytes of code + data! TODO: it should be easy to solve that with <<bios-disk-load>>, send a pull request :-) Here is full example that we could also adapt: http://3zanders.co.uk/2017/10/18/writing-a-bootloader3
* use use GCC's `-m` which does not produce "real" 16 bit code, but rather 32-bit code with `0x66` and `0x67` prefixes: https://wiki.osdev.org/X86-64_Instruction_Encoding#Legacy_Prefixes
* setting up the initial state and the linker script is much harder and error prone than with assembly

Therefore, for most applications, you will just want to use <<multiboot>> instead, which overcomes all of those problems.

To disassemble the generated C code, try:

....
objdump -D -m i8086 main.elf
....

but note that it still contains references to 32-bit references, e.g.:

....
00007c17 <main>:
    7c17:       66 55                   push   %ebp
    7c19:       66 89 e5                mov    %esp,%ebp
    7c1c:       66 83 ec 10             sub    $0x10,%esp
....

This is because those instructions are modified by the prefix `0x66`, which makes them behave like 32-bit.

=== No linker script

Print `hello world` without using an explicit linker script:

....
make -C no-linker-script run
....

Sources:

* link:no-linker-script/Makefile[]
* link:no-linker-script/main.S[]

Uses the default host `ld` script, not an explicit one set with `-T`. Uses:

* `-tText`
* `.org` inside each assembly file
* `_start` must be present to avoid a warning, since the default linker script expects it

This is a hack, it can be more convenient for quick and dirty tests, but just don't use it.

== BIOS

The BIOS is one of the most well known firmwares in existence.

A firmware is a software a software that:

* runs before the OS / bootloader to do very low level setup
* usually closed source, provided by the vendor, and interacts with undocumented hardware APIs
* offers an API to the OS / bootloader, that allows you to do things like quick and dirty IO
* undistinguishable from an OS, except that is it usually smaller

BIOS is old, non-standardized, x86 omnipresent and limited.

<<uefi>> is the shiny new overbloated thing.

If you are making a serious OS, use it as little as possible.

BIOS Can only be used in <<real-mode>>.

BIOS functions are all accessed through the `int` instruction:

....
mov <function-id>, %ah
int <interrupt-id>
....

Function arguments are stored in other registers.

The interrupt IDs are traditionally in hex as:

....
10h
....

which is the same as `0x10`.

Each `interrupt-id` groups multiple functions with similar functions, e.g. `10h` groups functions with video related functionality.

Bibliography:

* https://en.wikipedia.org/wiki/BIOS
* http://wiki.osdev.org/BIOS

=== BIOS documentation

Does any official documentation or standardization exist?

* https://en.wikipedia.org/wiki/BIOS_interrupt_call#Interrupt_table
* http://www.ctyme.com/intr/int.htm Ralf Brown's Interrupt List. Everyone says that this is the ultimate unofficial compilation.
* https://en.wikipedia.org/wiki/INT_10H good quick summary
* http://www.scs.stanford.edu/nyu/04fa/lab/specsbbs101.pdf says little about interrupts, I don't understand it's scope.

=== BIOS examples

Print a single `@` character:

....
./run bios_putc
....

Source: link:bios_putc.S[]

Print a newline:

....
./run bios_newline
....

Source: link:bios_newline.S[]

Outcome:

....
hello
     world
....

Carriage returns are needed just like in old days:

....
./run bios_carriage_return
....

Source: link:bios_carriage_return.S[]

Outcome:

....
hello
world
....

Change the current cursor position:

....
./run bios_cursor_position
....

Source: link:bios_cursor_position.S[]

Outcome:

....
cb
....

==== BIOS color

Color codes: https://en.wikipedia.org/wiki/BIOS_color_attributes

Write a character N times with given color:

....
./run bios_color
....

Source: link:bios_color.S[]

Outcome:

....
bcd
....

where:

* `b` and `c` have red foreground, and green background
* `d` has the default color (gray on black)

Change the background color to red for the entire screen and print an `a` character:

....
./run bios_background
....

Source: link:bios_background.S[]

==== BIOS scroll

Scroll the screen:

....
./run bios_scroll
....

Source: link:bios_scroll.S[]

Outcome:

....
a
  c
 GG
   d
....

where `G` are empty green squares.

How it works:

Before scroll:

....
a
 b
  c
   d
....

We then choose to act on the rectangle with corners (1, 1) and (2, 2) given by `cx` and `dx`:

....
a
 XX
 YY
   d
....

and scroll that rectangle up by one line.

`Y` is then filled with the fill color green

===== BIOS clear screen

Subset of scroll:

....
./run bios_clear_screen
....

Source: link:bios_clear_screen.S[]

Outcome:

....
b
....

on red foreground, and the entire screen in green background, without any initial SeaBIOS messages.

==== BIOS draw pixel

Make the pixel at position (1, 1) clear red color (0Ch) in <<video-mode-13h>>:

....
./run bios_pixel
....

Source: link:bios_pixel.S[]

You may have to look a bit hard to see it.

Draw a line of such pixels:

....
./run bios_pixel_line
....

Source: link:bios_pixel_line.S[]

Advanced graphics!

==== BIOS keyboard

Get one character from the user via the keyboard, increment it by one, and print it to the screen, then halt:

....
./run bios_keyboard
....

Source: link:bios_keyboard.S[]

Type a bunch of characters and see them appear on the screen:

....
./run bios_keyboard_loop
....

Source: link:bios_keyboard_loop.S[]

Do try `Ctrl-key` combinations.

Bibliography: https://stackoverflow.com/questions/4113250/how-to-handle-keyboard-in-real-mode-through-bios-interrupts/32682518#32682518

==== BIOS disk load

Load a stage 2 from disk with `int 13h` and run it:

....
./run bios_disk_load
....

Source: link:bios_disk_load.S[]

Outcome:

....
a
....

This character was printed from stage 2.

Load two sectors instead of just one:

....
./run bios_disk_load2
....

Source: link:bios_disk_load2.S[]

Outcome:

....
ab
....

where `a` was printed from code on the first block, and `b` from code on the second block.

This shows that each sector is 512 bytes long.

GRUB 2.0 makes several calls to it under `grub-core/boot/i386/pc`.

TODO: not working on Bochs: `BOUND_GdMa: fails bounds test`.

But it does work on QEMU and <<thinkpad-t400>>.

Bibliography:

* https://en.wikipedia.org/wiki/INT_13H
* http://wiki.osdev.org/ATA_in_x86_RealMode_%28BIOS%29
* https://thiscouldbebetter.wordpress.com/2011/03/15/creating-a-bootable-program-in-assembly-language/
* http://stackoverflow.com/questions/19381434/cannot-read-disk-sectors-in-assembly-language
* http://stackoverflow.com/questions/15497842/read-a-sector-from-hard-drive-with-int-13h

==== BIOS detect memory

TODO failed attempt at detecting how big our memory is with `int 15h`:

....
./run bios_detect_memory
....

Source: link:bios_detect_memory.S[]

Seems to output trash currently.

This is important in particular so that you can start your stack there when you enter <<protected-mode>>, since the stack grows down.

In 16-bit mode, it does not matter much, since most modern machines have all addressable memory there, but in 32-bit protected it does, as our emulator usually does not have all 4Gb. And of course, 64-bit RAM is currently larger than the total RAM in the world.

`int 15` returns a list: each time you call it a new memory region is returned.

The format is not too complicated, and documented at: http://wiki.osdev.org/Detecting_Memory_%28x86%29#Detecting_Upper_Memory

* 8 bytes: base address of region.
* 8 bytes: length of region.
* 4 bytes: type or region. 1 for usable RAM.
* 4 bytes: some ACPI stuff that no one uses?

Bibliography: http://wiki.osdev.org/Detecting_Memory_%28x86%29

===== Low vs high memory

TODO example.

`int 15h` can detect low or high memory. How are they different?

==== BIOS sleep

Count to infinity, sleep one second between each count:

....
./run bios_sleep
....

Source: link:bios_sleep.S[]

Polls time counter that BIOS keeps up to date at `0x046C` with frequency 18.2Hz eighteen times.

Bibliography: https://stackoverflow.com/questions/9971405/how-to-display-a-number-on-the-screen-and-and-sleep-for-one-second-with-dos-x86/9973442#9973442

==== BIOS initial state

Check the initial state the firmware leaves us by printing the contents of several registers:

....
./run bios_initial_state
....

Source: link:bios_initial_state.S[]

Outcome:

....
ax = 00 00
bx = 00 00
cx = 00 00
dx = 80 00
cs = 00 00
ds = 00 00
es = 00 00
fs = 00 00
gs = 00 00
ss = 00 00
cr0 = 53 FF 00 F0
....

`dx` seems to be like the only interesting regular register: the firmware stores the value of the current disk number to help with `int 15h` there. Thus it usually contains `0x80`.

=== dmidecode

Get BIOS information. On host:

....
sudo dmidecode
....

Standardized by: https://en.wikipedia.org/wiki/Distributed_Management_Task_Force

TODO: how is it obtained at the low level?

Bibliography:

* http://stackoverflow.com/questions/20604644/how-to-check-the-bios-version-or-name-in-linux-through-command-prompt
* https://en.wikipedia.org/wiki/System_Management_BIOS SMBIOS

=== SeaBIOS

http://www.seabios.org/SeaBIOS

Open source x86 BIOS implementation.

Default BIOS for QEMU and KVM.

== No BIOS

Here we will collect some examples that do stuff without using the BIOS!

These tend to be less portable, not sure they will work on real hardware.

Also they might need to rely on undocumented features.

But they were verified in QEMU.

If you are serious about this, study <<coreboot>>.

=== No BIOS hello world

....
./run no_bios_hello_world
....

Source: link:no_bios_hello_world.S[]

Outcome:

....
hello world
....

with red foreground and blue background shows on the top left of the cleared screen.

This example uses the fact that BIOS maps video memory to address 0xB8000.

We can then move 0xB800 to a segment register and use segment:offset addressing to access this memory.

Then we can show characters by treating `0xB800:0000` as a `uint16_t` array, where low 8 bytes is the ASCII character, and the high 8 bytes is the color attribute of this character.

== Modes of operation

The x86 processor has a few modes, which have huge impact on how the processor works.

Covered on the <<intel-manual>> Volume 3. Specially useful is the "Figure 2-3. Transitions Among the Processor’s Operating Modes" diagram.

The modes are:

* Real-address, usually known just as "real mode"
* Protected
* System management
* IA-32e. Has two sub modes:
** Compatibility
** 64-bit
* Virtual-8086 Mode

Transition tables:

....
(all modes)
|
| Reset
|
v
+---------------------+
| Real address (PE=0) |
+---------------------+
^
|
| PE
|
v
+------------------------+
| Protected (PE=1, VM=0) |
+------------------------+
^                   ^
|                   |
|                   | VM
|                   |
v                   v
+--------------+    +---------------------+
| IA-32e       |    | Virtual-8086 (VM=1) |
+--------------+    +---------------------+
....

and:

....
+------------------------+
| System management mode |
+------------------------+
|          ^
|          |
| RSM      | SMI#
|          |
v          |
(All other modes)
....

The IA-32e transition is trickier, but clearly described on the <<intel-manual>> Volume 3 - 9.8.5 "Initializing IA-32e Mode":

____
Operating systems should follow this sequence to initialize IA-32e mode:

1. Starting from protected mode, disable paging by setting `CR0.PG = 0`. Use the `MOV CR0` instruction to disable paging (the instruction must be located in an identity-mapped page).
2. Enable physical-address extensions (PAE) by setting CR4.`PAE = 1`. Failure to enable PAE will result in a `#GP` fault when an attempt is made to initialize IA-32e mode.
3. Load `CR3` with the physical base address of the Level 4 page map table (PML4).
4. Enable IA-32e mode by setting `IA32_EFER.LME = 1`.
5. Enable paging by setting `CR0.PG = 1`. This causes the processor to set the `IA32_EFER.LMA` bit to 1. The `MOV CR0` instruction that enables paging and the following instructions must be located in an identity-mapped page (until such time that a branch to non-identity mapped pages can be effected).
____

=== Legacy modes

The term defined in the <<intel-manual>> Volume 3 - CHAPTER 2 "SYSTEM ARCHITECTURE OVERVIEW":

____
Real mode, protected mode, virtual 8086 mode, and system management mode. These are sometimes referred to as legacy modes.
____

In other words: anything except IA-32e and System management mode.

This further suggests that real, protected and virtual mode are not the main intended modes of operation.

=== Real mode

http://wiki.osdev.org/Real_Mode

The CPU starts in this mode after power up.

All our <<bios>> examples are in real mode.

It is possible to use 32-bit registers in this mode with the "Operand Size Override Prefix" `0x66`.

TODO is it possible to access memory above 1M like this:

....
mov $1, 0xF0000000
mov $1, (%eax)
....

http://stackoverflow.com/questions/6917503/is-it-possible-to-use-32-bits-registers-instructions-in-real-mode

==== Real mode segmentation

....
./run real_segmentation
....

Source: link:real_segmentation.S[]

Outcome:

....
AAAAAA
....

We access the character `A` with segments in 6 different ways:

* `ds`, with explicit and implicit segment syntax
* `es`, `fs`, `gs`, `ss`

Segment registers modify the addresses that instructions actually use as:

....
<segment> * 16 + <original-address>
....

This implies that:

* 20 bits of memory (1MB) instead of the 16 bits (256kB) that normally fits into registers. E.g., to address:
+
....
0x84000
....
+
we can use:
+
....
0x8000  (segment)
0x 4000 (address)
-------
0x84000
....
* most addresses can be encoded in multiple ways, e.g.:
+
....
0x100
....
+
can be encoded as either of:
+
** segment = `0x10`, address = `0`
** segment = `0`, address = `0x100`
** segment = `0x1`, address = `0xF0`

`fs` and `gs` are general purpose: they are not affected implicitly by any instructions. All others will be further exemplified.

===== CS

https://stackoverflow.com/questions/17777146/what-is-the-purpose-of-cs-and-ip-registers-in-intel-8086-assembly/33177253#33177253

Affects the code address pointer:

....
./run cs
....

Source: link:cs.S[]

Outcome:

....
00
01
02
....

`CS` is set with the `ljmp` instruction, and we use it to skip `.skip` zero gaps in the code.

===== SS

....
./run ss
....

Source: link:ss.S[]

Outcome:

....
0102
....

The second byte is 16 bytes after the first, and is accessed with `SP = 1`.

`SS` affects instructions that use `SP` such as `PUSH` and `POP`: those will actually use `16 * SS + SP` as the actual address.

===== ES

TODO: this does seem to have special properties as used by string instructions.

===== Segment register encoding

....
objdump -D -b binary -m i8086 segment_registers.img
....

shows that non `ds` encodings are achieved through a prefix:

....
20:   a0 63 7c                mov    0x7c63,%al
34:   26 a0 63 7c             mov    %es:0x7c63,%al
40:   64 a0 63 7c             mov    %fs:0x7c63,%al
4c:   65 a0 63 7c             mov    %gs:0x7c63,%al
58:   36 a0 63 7c             mov    %ss:0x7c63,%al
....

This makes `ds` the most efficient one for data access, and thus a good default.

==== Interrupts

Create an interrupt handler and handle an interrupt:

....
./run interrupt
....

Source: link:interrupt.S[]

Outcome:

....
ab
....

It works like this:

* print `a` an interrupt handler `0`
* jump back to main code
* print `b`

TODO: is STI not needed because this interrupt is not maskable?

Same with interrupt handler `1`:

....
./run interrupt1
....

Source: link:interrupt1.S[]

TODO understand: attempt to create an infinite loop that calls the interrupt from the handler:

....
./run interrupt_loop
....

Source: link:interrupt_loop.S[]

QEMU exits with:

....
Trying to execute code outside RAM or ROM at 0x000a0000
....

Handle a division by zero:

....
./run interrupt_zero_divide
....

Source: link:interrupt_zero_divide.S[]

TODO understand:

* expected outcome: prints values from 0 to `0xFFFF` in an infinite loop.
* actual outcome: stops at `0081`

Apparently when there is an exception, `iret` jumps back to the line that threw the exception itself, not the one after, which leads to the loop:

* https://stackoverflow.com/questions/33029457/what-to-do-in-interrupt-handler-for-divide-by-zero
* https://stackoverflow.com/questions/9151429/os-development-how-to-avoid-an-infinite-loop-after-an-exception-routine

But then why does it stop at `0081`? And if we set the initial value to `0x0090`, it just runs once.

===== int

* long jumps to the CS : IP found in the corresponding interrupt vector.
* pushes EFLAGS to let them be restored by iret?

===== iret

Jumps back to the next instruction to be executed before the interrupt came in.

Restores EFLAGS and other registers TODO which?

Vs `jmp`: http://stackoverflow.com/questions/10462884/must-iret-be-used-when-returning-from-an-interrupt

===== Interrupt service routines

Fancy name for the handler: http://wiki.osdev.org/Interrupt_Service_Routines

===== IVT

Interrupt vector table: https://wiki.osdev.org/IVT

The real mode in-memory table that stores the address for the handler for each interrupt.

In <<protected-mode>>, the analogous structure is the <<idt>>.

The base address is set in the interrupt descriptor table register (IDTR), which can be modified with the <<lidt>> instruction.

The default address is `0x0`.

The format of the table is:

....

IDTR -> +-----------------------+
0       |Address      (2 bytes) |
2       |Code segment (2 bytes) |
        +-----------------------+
        +-----------------------+
4 ----> |Address      (2 bytes) |
6       |Code segment (2 bytes) |
        +-----------------------+
        +-----------------------+
8 ----> |Address      (2 bytes) |
A       |Code segment (2 bytes) |
        +-----------------------+

...     ...
....

====== lidt

Set the value of the IDTR, and therefore set the base address of the <<ivt>>:

....
./run lidt
./run lidt2
./run lidt0
....

Sources:

* link:lidt.S[]
* link:lidt2.S[]
* link:lidt0.S[]

TODO not working.

Expected outcome:

....
ab
....

Actual outcome: infinite reboot loop.

Actual outcome if we comment out the `PUTC`:

* `lidt`: still infinite reboot loop
* `lidt2` and `lidt0`: halt apparently

I think I understand that `lidt` takes as input a memory address, and the memory at that address must contain:

* 2 bytes: total size of the IVT in bytes
* 4 bytes: base address of the IVT. Higher byte is ignored in real mode, since addresses are not 4 bytes long.

=== Protected mode

Print `hello world` in protected mode:

....
./run protected_mode
....

Source: link:protected_mode.S[]

Major changes from real mode:

* <<vga>> must be used for output since <<bios>> is not available in protected mode.
* <<protected-mode-segmentation,segmentation>> takes effect immediately, so we have to set the <<gdt>> up
* we have to encode instructions differently, thus a `.code32` is needed. 16-bit mode 32-bit instructions are encodable with a special prefix.

Bibliography:

* http://stackoverflow.com/questions/28645439/how-do-i-enter-32-bit-protected-mode-in-nasm-assembly Initially adapted from this.
* http://wiki.osdev.org/Journey_To_The_Protected_Land
* http://wiki.osdev.org/Protected_Mode
* https://github.com/chrisdew/xv6/blob/master/bootasm.S
* https://thiscouldbebetter.wordpress.com/2011/03/17/entering-protected-mode-from-assembly/ FASM based. Did not word on first try, but looks real clean.
* http://skelix.net/skelixos/tutorial02_en.html
* Linux kernel v4.12 `arch/x86/include/asm/segment.h`

==== Intel protected mode example

Source: link:intel-protected/[]

The <<intel-manual>> Volume 3 - 9.10 "INITIALIZATION AND MODE SWITCHING EXAMPLE" does contain an official example of how to go into protected mode.

However:

* the code is inside the PDF, which breaks all the formatting, so we have copied it here to this repo
* TODO there is no known tool that can actually compile that syntax... although MASM should be close:
** http://computer-programming-forum.com/46-asm/6d9e8b7acea2d4cc.htm
** http://coding.derkeiler.com/Archive/Assembler/alt.lang.asm/2005-12/msg00028.html
** https://groups.google.com/forum/#!topic/comp.lang.asm.x86/9UZPQWwv-mQ 1994 comp.lang.asm.x86 topic

How can those guys be in business? >:-)

==== Protected mode draw pixel

TODO do it.

Things get much more involved than in real mode: http://stackoverflow.com/questions/14419088/how-to-draw-a-pixel-on-the-screen-in-protected-mode-in-x86-assembly

==== Protected mode segmentation

TODO: get working:

....
./run segmentation
....

Source: link:segmentation.S[]

Expected outcome:

....
x
a
b
....

Actual outcome:

....
x
a
....

Example of the effect on a memory access of changing the segment base address.

Without segment manipulation, the output would be just: TODO

===== Segmentation introduction

First read the paging tutorial, and in particular: https://cirosantilli.com/x86-paging#segmentation to get a feel for the type of register and data structure manipulation required to configure the CPU, and how segmentation compares to paging.

Segmentation modifies every memory access of a given segment by:

* adding an offset to it
* limiting how big the segment is

If an access is made at an offset larger than allowed an exception happens, which is like an interrupt, and gets handled by a previously registered handler.

Segmentation could be used to implement virtual memory by assigning one segment per program:

....
+-----------+--------+--------------------------+
| Program 1 | Unused | Program 2                |
+-----------+--------+--------------------------+
^           ^        ^                          ^
|           |        |                          |
Start1      End1     Start2                     End2
....

Besides address translation, the segmentation system also managed other features such as <<protection-rings>>. TODO: how are those done in 64-bit mode?

In Linux 32-bit for example, only two segments are used at all times: one at ring 0 for the kernel, and one another at privilege 3 for all user processes.

===== Segment selector

In protected mode, the segment registers `CS`, `DS`, `SS`, `ES`, `FS` and `GS` contain a data structure more complex than a simple address as in real mode, which contains a single number.

This 2 byte data structure is called a _segment selector_:

[options="header"]
|===
|Position (bits) |Size (bits) |Name |Description

|0
|2
|Request Privilege Level (RPL)
|Protection ring level, from 0 to 3.

|2
|1
|Table Indicator (TI)
a|
* 0: global descriptor table
* 1: local descriptor table

|3
|13
|Index
a|Index of the <<segment-descriptor>> to be used from the descriptor table.
|===

Like in real mode, this data structure is loaded on the registers with a regular `mov` mnemonic instruction.

Bibliography: <<intel-manual>> Volume 3 - 3.4.5 "Segment Descriptors".

===== GDT

Global descriptor table.

An in-memory array of <<segment-descriptor>> data structures:

The `Index` field of the <<segment-selector>> chooses which one of those segment descriptors is to be used.

The base address is set with the `lgdt` instruction, which loads from memory a 6 byte structure:

[options="header"]
|===
|Position (bytes) |Size (bytes) |Description

|0
|2
|Number of entries in the table

|2
|4
|Base address of the table
|===

Bibliography:

* https://en.wikipedia.org/wiki/Global_Descriptor_Table
* http://wiki.osdev.org/GDT

====== Local descriptor table

TODO vs global?

====== Null segment selector

<<intel-manual>> Volume 3 - 3.4.2 "Segment Selectors" says that we can't use the first entry of the GDT:

____
The first entry of the GDT is not used by the processor. A segment selector that points to this entry of the GDT (that is, a segment selector with an index of 0 and the TI flag set to 0) is used as a “null segment selector.” The processor does not generate an exception when a segment register (other than the CS or SS registers) is loaded with a null selector. It does, however, generate an exception when a segment register holding a null selector is used to access memory. A null selector can be used to initialize unused segment registers. Loading the CS or SS register with a null segment selector causes a general-protection exception (#GP) to be generated.
____

===== Segment descriptor

A data structure that is stored in the <<gdt>>.

Clearly described on the <<intel-manual>> Volume 3 - 3.4.5 "Segment Descriptors" and in particular Figure 3-8 "Segment Descriptor".

The Linux kernel v4.2 encodes it at: `arch/x86/include/asm/desc_defs.h` in `struct desc_struct`

===== Protection rings

https://stackoverflow.com/questions/18717016/what-are-ring-0-and-ring-3-in-the-context-of-operating-systems/44483439#44483439

TODO example. Jump to userspace, do something naughty, handler interrupt in kernel land.

==== IDT

Interrupt descriptor table.

Protected mode analogue to the <<ivt>>:

....
./run idt
....

Source: link:idt.S[]

Outcome:

....
int 0 handled
....

Handle interrupt 1 instead of 0:

....
./run idt1
....

Source: link:idt1.S[]

Outcome:

....
int 1 handled
....

Print `00000020\n` at `18.2 Hz` with the <<pit>>:

....
./run pit_protected
....

Source: link:pit_protected.S[]

Bibliography:

* https://wiki.osdev.org/Interrupt_Descriptor_Table
* https://en.wikipedia.org/wiki/Interrupt_descriptor_table
* http://www.jamesmolloy.co.uk/tutorial_html/4.-The%20GDT%20and%20IDT.html

The first 32 handlers are reserved by the processor and have predefined meanings, as specified in the <<intel-manual>> Volume 3 Table 3-3. "Intel 64 and IA-32 General Exceptions".

In the Linux kernel, https://github.com/torvalds/linux/blob/v4.2/arch/x86/entry/entry_64.S sets them all up: each `idtentry divide_error` call sets up a new one.

===== IDT divide by zero

Handle a division by zero:

....
./run idt_zero_divide
....

Source: link:idt_zero_divide.S[]

Outcome:

....
division by zero handled
....

Division by zero causes a Divide Error which Intel notes as `#DE`.

It is then handled by IDT 0.

DEs are not only for division by zero: they also happens on overflow. TODO example.

==== SMP

link:https://en.wikipedia.org/wiki/Symmetric_multiprocessing[Symmetric multiprocessing].

Verbose explanation: http://stackoverflow.com/questions/980999/what-does-multicore-assembly-language-look-like/33651438#33651438

Start multiple processors and make them interact:

....
./run smp
....

Source: link:smp.S[]

Outcome:

....
SMP started
....

Implies that SMP worked because a spinlock was unlocked by the second processor.

Try commenting out waking up the second processor and see it not get printed.

==== Paging

Verbose beginner's tutorial: https://cirosantilli.com/x86-paging

Change page tables and observe how that affects memory accesses:

....
./run paging
....

Source: link:paging.S[]

Outcome:

....
00001234
00005678
....

Implies that paging worked because we printed and modified the same physical address with two different virtual addresses.

Requires <<protected-mode>>.

===== Page fault

Generate and handle a page fault:

....
./run page_fault
....

Source: link:page_fault.S[]

Outcome:

....
Page fault handled. Error code:
00000002
....

This is printed from a page fault handler that we setup an triggered by writing to an unmapped address.

=== IA-32e mode

Wikipedia seems to call it long mode: https://en.wikipedia.org/wiki/Long_mode

Contains two sub-modes: <<64-bit-mode>> and <<compatibility-mode>>.

This controlled by the `CS.L` bit of the segment descriptor.

It appears that it is possible for user programs to modify that during execution from userland: http://stackoverflow.com/questions/12716419/can-you-enter-x64-32-bit-long-compatibility-sub-mode-outside-of-kernel-mode

TODO vs <<protected-mode>>.

=== 64-bit mode

64-bit is the major mode of operation, and enables the full 64 bit instructions.

There are currently no examples in this repo because I was lazy to make them.

As someone once brilliantly put it: https://twitter.com/garybernhardt/status/1106255947138125824

____
Watching an x86-64 CPU boot is like watching an amoeba slowly evolve into a dog.
____

The backward compatibility of x86 is mind boggling.

=== Compatibility mode

Compatibility mode emulates IA-32 and allows to run 32 and 16 bit code.

But 64 bit Linux and Windows don't seem to allow 16 bit code anymore?

* http://stackoverflow.com/questions/27868394/switch-from-64-bit-long-mode-to-32-bit-compatibility-mode-on-x64
* https://stackoverflow.com/questions/7829058/how-to-run-16-bit-code-on-32-bit-linux
* https://superuser.com/questions/140953/why-cant-a-64-bit-os-run-a-16-bit-application

Compatibility vs protected: https://stackoverflow.com/questions/20848412/modes-of-intel-64-cpu

== in and out instructions

x86 has dedicated instructions for certain IO operations: `in` and `out`.

These instructions take an IO address which identifies which hardware they will communicate to.

The IO ports don't seem to be standardized, like everything else: http://stackoverflow.com/questions/14194798/is-there-a-specification-of-x86-i-o-port-assignment

The Linux kernel wraps those instructions with the `inb` and `outb` family of instructions:

....
man inb
man outb
....

=== Memory mapped vs port mapped IO

Not all instruction sets have dedicated instructions such as `in` and `out` for IO.

In ARM for example, everything is done by writing to magic memory addresses.

The dedicated `in` and `out` approach is called "port mapped IO", and the approach of the magic addresses "memory mapp"

From an interface point of view, I feel that memory mapped is more elegant: port IO simply creates a second addresses space.

TODO: are there performance considerations when designing CPUs?

Bibliography: http://superuser.com/questions/703695/difference-between-port-mapped-and-memory-mapped-access

[[ps2-keyboard]]
=== PS/2 keyboard

Whenever you press a key down or up, the keyboard hex scancode is printed to the screen:

....
./run ps2_keyboard
....

Source: link:ps2_keyboard.S[]

Uses the PS/2 keyboard controller on `in 60h`: http://wiki.osdev.org/%228042%22_PS/2_Controller

The `in` always returns immediately with the last keyboard keycode: we then just poll for changes and print only the changes.

Scancode tables: TODO: official specs?

* https://en.wikipedia.org/wiki/Scancode#PC_compatibles
* http://flint.cs.yale.edu/cs422/doc/art-of-asm/pdf/APNDXC.PDF

TODO do this with the interrupt table instead of `in`. Failed attempt at: link:interrupt_keyboard.S[]

=== PS/2 mouse

TODO create an example:

* http://wiki.osdev.org/Mouse_Input
* Random threads with source code, ah those OS devs:
** https://forum.osdev.org/viewtopic.php?t=10247
** https://forum.osdev.org/viewtopic.php?t=24277
* https://courses.engr.illinois.edu/ece390/books/labmanual/io-devices-mouse.html

I am so going to make a pixel drawing program with this.

=== RTC

Real Time Clock: https://en.wikipedia.org/wiki/Real-time_clock

Get wall time with precision of seconds every second:

....
./run rtc
....

Source: link:rtc.S[]

Sample outcome:

....
00 01 02 03 04 10
....

which means:

____
3rd April 2010, 02 hours 01 minute and 00 seconds.
____

Uses `out 70h` and `in 71h` to query the hardware.

This hardware must therefore use a separate battery to keep going when we turn off the computer or remove the laptop battery.

We can control the initial value in QEMU with the option:

....
qemu-system-x86_64 -rtc base='2010-04-03T02:01:00'
....

The RTC cannot give accuracy greater than seconds. For that, consider the <<pit>>, or the <<hpet>>.

Bibliography:

* http://wiki.osdev.org/RTC
* http://wiki.osdev.org/CMOS
* http://stackoverflow.com/questions/1465927/how-can-i-access-system-time-using-nasm
* https://github.com/torvalds/linux/blob/v4.2/arch/x86/kernel/rtc.c#L121

=== PIT

Programmable Interval Timer: https://en.wikipedia.org/wiki/Programmable_interval_timer

Superseded by the <<hpet>>.

Print `a\n` with the minimal frequency possible of `0x1234DD / 0xFFFF = 18.2 Hz`:

....
./run pit
....

Source: link:pit.S[]

Make the PIT generate a single interrupt instead of a frequency:

....
./run pit_once
....

Source: link:pit_once.S[]

Outcome:

....
a
....

TODO I think this counts down from the value value in channel 0, and therefore allows to schedule a single event in the future.

The PIT can generate periodic interrupts (or <<pc-speaker,sound>>!) with a given frequency to `IRQ0`, which on real mode maps to interrupt 8 by default.

Major application: interrupt the running process to allow the OS to schedule processes.

The PIT 3 channels that can generate 3 independent signals

* channel 0 at port `40h`: generates interrupts
* channel 1 at port `41h`: not to be used for some reason
* channel 2 at port `42h`: linked to the speaker to generate sounds

Port `43h` is used to control signal properties except frequency, which goes in the channel ports, for the 3 channels.

Bibliography:

* http://wiki.osdev.org/PIT
* https://en.wikipedia.org/wiki/Intel_8253 that is the circuit ID for the PIT.
* http://kernelx.weebly.com/programmable-interval-timer.html

==== PIT frequency

We don't control the frequency of the PIT directly, which is fixed at `0x1234DD`.

Instead, we control a frequency divisor. This is a classic type of discrete electronic circuit: https://en.wikipedia.org/wiki/Frequency_divider

The magic frequency comes from historical reasons to reuse television hardware according to link:https://wiki.osdev.org/Programmable_Interval_Timer[], which in turn is likely influenced by some physical properties of crystal oscillators.

The constant `1193181 == 0x1234DD` has 2 occurrences on Linux 4.16.

==== HPET

Newer <<pit>>.

TODO example.

* https://en.wikipedia.org/wiki/High_Precision_Event_Timer
* https://wiki.osdev.org/HPET

==== PC speaker

http://wiki.osdev.org/PC_Speaker

....
./run pc_speaker
....

Source: link:pc_speaker.S[]

Outcome: produces a foul noisy noise using the PC speaker hardware on `out 61h`

QEMU only plays the sound if we give it the option:

....
-soundhw pcspk
....

The beep just uses the <<pit>> Channel 2 to generate the frequency.

Extracted from: https://github.com/torvalds/linux/blob/v4.2/arch/x86/realmode/rm/wakemain.c#L38 The kernel has a Morse code encoder using it!

Bibliography:

* https://courses.engr.illinois.edu/ece390/books/labmanual/io-devices-speaker.html
* http://fly.srk.fer.hr/GDM/articles/sndmus/speaker1.html

== Video mode

There are several video modes.

Modes determine what interrupt functions can be used.

There are 2 main types of modes:

* text, where we operate character-wise
* video, operate byte-wise

Modes can be set with `int 0x10` and `AH = 0x00`, and get with `AH = 0x0F`

The most common modes seem to be:

* 0x01: 40x25 Text, 16 colors, 8 pages
* 0x03: 80x25 Text, 16 colors, 8 pages
* 0x13: 320x200 Graphics, 256 colors, 1 page

You can add 128 to the modes to prevent them from clearing the screen.

Taken from: https://courses.engr.illinois.edu/ece390/books/labmanual/graphics-int10h.html

A larger list: http://www.columbia.edu/~em36/wpdos/videomodes.txt

See also: http://wiki.osdev.org/How_do_I_set_a_graphics_mode

=== Video mode 13h

https://en.wikipedia.org/wiki/Mode_13h

Example at: <<bios-draw-pixel>>

Video Mode `13h` has: 320 x 200 Graphics, 256 colors, 1 page.

The color encoding is just an arbitrary palette that fits 1 byte, it is not split colors like R  R  R  G  G  G  B  B or anything mentioned at: https://en.wikipedia.org/wiki/8-bit_color. Related: http://stackoverflow.com/questions/14233437/convert-normal-256-color-to-mode-13h-version-color

=== VGA

* https://en.wikipedia.org/wiki/Video_Graphics_Array
* https://en.wikipedia.org/wiki/VGA-compatible_text_mode

TODO: what is it exactly?

BIOS cannot be used when we move into <<protected-mode>>, but we can use the VGA interface to get output out of our programs.

Have a look at the macros prefixed with `VGA_` inside link:common.h[].

== Power

=== Reboot

Infinite reboot loop on emulator!

....
./run reboot
....

Source: link:reboot.S[]

TODO why does it work?

Bibliography: http://stackoverflow.com/questions/32682152/how-to-reboot-in-x86-assembly-from-16-bit-real-mode

=== APM

Turn on and immediately shutdown the system closing QEMU:

....
./run apm_shutdown
....

Source: link:apm_shutdown.S[]

Fancier version copied from http://wiki.osdev.org/APM (TODO why is that better):

....
./run apm_shutdown2
....

Source: link:apm_shutdown2.S[]

Older than <<acpi>> and simpler.

By Microsoft in 1995. Spec seems to be in RTF format...

Can't find the URL. A Google cache: https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0CB0QFjAAahUKEwj7qpLN_4XIAhWCVxoKHa_nAxY&url=http%3A%2F%2Fdownload.microsoft.com%2Fdownload%2F1%2F6%2F1%2F161ba512-40e2-4cc9-843a-923143f3456c%2FAPMV12.rtf&usg=AFQjCNHoCx8gHv-w08Dn_Aoy6Q3K3DLWRg&sig2=D_66xvI7Y2n1cvyB8d2Mmg

Bibliography:

* https://en.wikipedia.org/wiki/Advanced_Power_Management
* http://wiki.osdev.org/APM
* http://wiki.osdev.org/Shutdown
* http://stackoverflow.com/questions/21463908/x86-instructions-to-power-off-computer-in-real-mode
* http://stackoverflow.com/questions/678458/shutdown-the-computer-using-assembly
* http://stackoverflow.com/questions/3145569/how-to-power-down-the-computer-from-a-freestanding-environment

=== ACPI

TODO example

ACPI https://en.wikipedia.org/wiki/Advanced_Configuration_and_Power_Interface

Newer and better.

Now managed by the same group that manages UEFI.

Spec:

* current: http://uefi.org/specifications
* old: http://www.uefi.org/acpi/specs

== UEFI

https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface

Successor for <<bios>>.

All <<test-hardware,laptops I tested BIOS with>> had UEFI, so UEFI must have a BIOS emulation mode for backwards compatibility: https://www.howtogeek.com/56958/htg-explains-how-uefi-will-replace-the-bios/

Made by Intel, mostly MIT open source, which likely implies that vendors will hack away closed source versions.

link:https://mjg59.dreamwidth.org/10014.html[Matthew Garrett says] it is huge: larger than Linux without drivers.

Since it is huge, it inevitably contains bugs. Garret says that Intel sometimes does not feel like updating the firmware with bugfixes.

UEFI offers a large API comparable to what most people would call an operating system:

* https://software.intel.com/en-us/articles/uefi-application mentions a POSIX C library port
* https://lwn.net/Articles/641244/ mentions a Python interpreter port!

ARM is considering an implementation https://wiki.linaro.org/ARM/UEFI

=== UEFI example

....
make -C uefi run
....

TODO get a hello world program working:

* http://www.rodsbooks.com/efi-programming/hello.html Best source so far: allowed me to compile the hello world! TODO: how to run it now on QEMU and real hardware?
* https://fedoraproject.org/wiki/Using_UEFI_with_QEMU
* https://wiki.ubuntu.com/UEFI/OVMF
* https://github.com/tqh/efi-example

Running without image gives the UEFI shell, and a Linux kernel image booted fine with it: link:http://unix.stackexchange.com/a/228053/32558[], so we just need to generate the image.

The blob `uefi/ovmf.fd` IA32 r15214 was downloaded from: https://sourceforge.net/projects/edk2/files/OVMF/OVMF-IA32-r15214.zip/download TODO: automate building it from source instead, get rid of the blob, and force push it away from history. Working build setup sketch: https://github.com/cirosantilli/linux-cheat/blob/b1c3740519eff18a7707de981ee3afea2051ba10/ovmf.sh

It seems that they have moved to GitHub at last: https://github.com/tianocore/tianocore.github.io/wiki/How-to-build-OVMF/e372aa54750838a7165b08bb02b105148e2c4190

=== UEFI Bibliography

* https://www.youtube.com/watch?v=V2aq5M3Q76U hardcore kernel dev Matthew Garrett saying how bad UEFI is
* https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface
* http://wiki.osdev.org/UEFI

== Coreboot

TODO minimal examples.

https://en.wikipedia.org/wiki/Coreboot

https://www.coreboot.org

Open source hippie freedom loving cross platform firmware that attempts to replace BIOS and UEFI for the greater good of mankind.

== GRUB

link:grub/README.adoc[] TODO cleanup and exemplify everything in that file. Some hosty stuff needs to go out maybe.

=== GRUB chainloader

....
make -C grub/chainloader run
....

Outcome: you are left in an interactive GRUB menu with two choices:

* `hello-world`: go into a hello world OS
* `self +1`: reload ourselves, and almost immediately reload GRUB and fall on the same menu as before

This example illustrates the `chainloader` GRUB command, which just loads a boot sector and runs it: https://www.gnu.org/software/grub/manual/grub/html_node/chainloader.html

This is what you need to boot systems like Windows which GRUB does not know anything about: just point to their partition and let them do the job.

Both of the menu options are implemented with `chainloader`:

* `hello-world`:
+
Loads a given image file within the partition.
+
After build, `grub-mkrescue` creates a few filesystems, and `grub/chainloader/iso/boot/main.img` is placed inside one of those filesystems.
+
This illustrates GRUB's awesome ability to understand certain filesystem formats, and fetch files from them, thus allowing us to pick between multiple operating systems with a single filesystem.
+
It is educational to open up the generated `grub/chainloader/main.img` with the techniques described at https://askubuntu.com/questions/69363/mount-single-partition-from-image-of-entire-disk-device/673257#673257 to observe that the third partition of the image is a VFAT filesystem, and that it contains the `boot/main.img` image as a regular file.
* `self +1`: uses the syntax:
+
....
chainloader +1
....
+
which reloads the first sector of the current partition, and therefor ourselves.

TODO: why does it fail for hybrid ISO images? http://superuser.com/questions/154134/grub-how-to-boot-into-iso-partition#comment1337357_154271

=== GRUB linux

TODO get working.

OK, let's have some fun and do the real thing!

....
make -C grub/linux run
....

Expected outcome: GRUB menu with a single `Buildroot` entry. When you select it, a tiny pre-built Linux image boots from: https://github.com/cirosantilli/linux-kernel-module-cheat

Actual outcome: after selecting the entry, nothing shows on the screen. Even if we fix this, we will then also need to provide a rootfs somehow: the `initrd` GRUB command would be a simple method, that repo can also generate initrd images: https://github.com/cirosantilli/linux-kernel-module-cheat/tree/c06476bfc821659a4731d49e808f45e8c509c5e1#initrd Maybe have look under Buildroot `boot/grub2` and copy what they are doing there.

The GRUB command is of form:

....
linux /boot/bzImage root=/dev/sda1 console=tty1
....

so we see that the kernel boot parameters are passed right there, for example try to change the value of the `printk.time` parameter:

....
printk.time=y
....

and see how the dmesg times not get printed anymore.

== Multiboot

https://en.wikipedia.org/wiki/Multiboot_Specification

Standard created by GRUB for booting OSes.

Multiboot files are an extension of ELF files with a special header.

Advantages: GRUB does housekeeping magic for you:

* you can store the OS as a regular file inside a filesystem
* your program starts in 32-bit mode already, not 16 bit real mode
* it gets the available memory ranges for you

Disadvantages:

* more boilerplate

GRUB leaves the application into a well defined starting state.

It seems that Linux does not implement Multiboot natively, but GRUB supports it as an exception: http://stackoverflow.com/questions/17909429/booting-a-non-multiboot-kernel-with-grub2

=== Multiboot hello world

QEMU supports multiboot natively https://stackoverflow.com/questions/25469396/how-to-use-qemu-properly-with-multi-boot-headers/32550281#32550281:

....
make -C multiboot/hello-world run
....

which actually runs:

....
qemu-system-i386 -kernel 'main.elf'
....

where `main.elf` is the multiboot file we generated.

Outcome:

....
hello world
....

Or you can use `grub-mkrescue` to make a multiboot file into a bootable ISO or disk:

....
qemu-system-x86_64 -drive file=main.img,format=raw
....

The `main.img` file can also be burned to a USB and run on real hardware.

Example originally minimized from https://github.com/programble/bare-metal-tetris

This example illustrates the `multiboot` GRUB command: https://www.gnu.org/software/grub/manual/grub/html_node/multiboot.html

=== osdev multiboot hello world

We also track here the code from: link:http://wiki.osdev.org/Bare_Bones[]:

....
make -C multiboot/osdev run
....

Outcome:

....
hello world
....

This is interesting as it uses C as much as possible with some GAS where needed.

This should serve as a decent basis for starting a pet OS. But please don't, there are enough out there already :-)

== Tests

=== Unit tests

Tests for utilities defined in this repo, as opposed to x86 or external firmware concepts.

TODO: implement the function and enable this test: link:test_vga_print_bytes.S[]

==== PRINT_BYTES

Print several bytes in human readable form:

....
./run test_print_bytes
....

Source: link:test_print_bytes.S[]

Outcome:

....
40 41 42 43 44 45 46 47
48 49 4A 4B 4C 4D 4E 4F
50
....

==== PIT_SLEEP_TICKS

Print `a\n` with frequency 2Hz:

....
./run test_pit_sleep_ticks
....

Source: link:test_pit_sleep_ticks.S[]

Same but in protected mode:

....
./run test_pit_sleep_protected
....

Source: link:test_pit_sleep_protected.S[]

=== Test hardware

==== ThinkPad T400

Most of this repo was originally tested on a link:https://www.cnet.com/products/lenovo-thinkpad-t400/specs/[Lenovo ThinkPad T400].

Unfortunately it broke and I threw it away, and I didn't write down the exact specs before doing so, notably the bootloader version.

==== ThinkPad T430

Then, when I moved to a new ThinkPad, I tested some of the examples on the link:https://www.cnet.com/products/lenovo-thinkpad-t400/specs/[Lenovo ThinkPad T430] I originally used to write this :-)

Firmware: UEFI BIOS 1.16.

== About

=== System vs userland

This repository covers only things that can only be done from ring 0 (system) and not ring 3 (userland).

Ring 3 is covered at: https://github.com/cirosantilli/x86-assembly-cheat

An overview of rings 0 and 3 can be found at: https://stackoverflow.com/questions/18717016/what-are-ring-0-and-ring-3-in-the-context-of-operating-systems/44483439#44483439

=== One minimal concept per OS

There are a few tutorials that explain how to make an operating system and give examples of increasing complexity with more and more functionality added: <<progressive-tutorials>>.

This is not one of them.

The goal of this repository is to use the minimal setup possible to be able to observe _a single_ low-level programming concept for each minimal operating system we create.

This is not meant provide a template from which you can write a real OS, but instead to illustrate how those low-level concepts work in isolation, so that you can use that knowledge to implement operating systems or drivers.

Minimal examples are useful because it is easier to observe the requirements for a given concept to be observable.

Another advantage is that it is easier to DRY up minimal examples with macros or functions, which is much harder on progressive OS template tutorials, which tend to repeat big chunks of code between the examples.

=== To C or not to C

Using C or not is a hard choice.

It does make it much easier to express higher level ideas, and gives portability.

However, it increases the complexity that one has to understand a bit, so I decided to stay away from it when I wrote this tutorial.

But I have since change my mind, and if I ever touch this again seriously, I would rewrite it in C based on <<c-hello-world>> and Newlib: https://electronics.stackexchange.com/questions/223929/c-standard-libraries-on-bare-metal/400077#400077

If this is done, we this repo should then be merged into: https://github.com/cirosantilli/linux-kernel-module-cheat/tree/87e846fc1f9c57840e143513ebd69c638bd37aa8#baremetal-setup together with the ARM Newlib baremetal setups present there.

=== Serial UART

What the heck is a serial in the real world: https://unix.stackexchange.com/questions/307390/what-is-the-difference-between-ttys0-ttyusb0-and-ttyama0-in-linux/367882#367882

Currently all text output is done the display, and that was a newbie design choice from before I knew the serial existed. The serial is just generally more minimal and elegant than the display, and should have been used instead.

....
./run bios_serial
cat bios_serial.tmp.serial
....

On QEMU, we see the serial output on the host terminal:

....
hello world
....

and on Bochs we redirect it to a file:

....
./run bios_serial bochs
cat bios_serial.tmp.serial
....

Source: link:bios_serial.S[]

TODO: failed attempt without BIOS:

....
./run serial
....

Source: link:serial.S[]

Like every other of those old hardwares, it is impossible to find its documentation, must be rotting on some IBM mainframe that is not connected to the internet, so we go for:

* OSDev: https://wiki.osdev.org/Serial_Ports
* Samy likely just copied OSDev that for his: https://github.com/SamyPesse/How-to-Make-a-Computer-Operating-System/blob/eb30f8802fac9f0f1c28d3a96bb3d402bdfc4687/src/kernel/modules/x86serial.cc#L38

Bibliography:

* https://stackoverflow.com/questions/22571379/intel-galileo-bare-metal-uart
* https://stackoverflow.com/questions/27594297/how-to-print-a-string-to-the-terminal-in-x86-64-assembly-nasm-without-syscall

This would open up:

* gem5 benchmarking and exploration, currently blocked on https://stackoverflow.com/questions/50364863/how-to-get-graphical-gui-output-and-user-touch-keyboard-mouse-input-in-a-ful/50364864#50364864
* the output stays persistently on the host terminal. So we can run QEMU without a GUI, immediatily shutdown the machine it at the end, and not have to close QEMU manually all the time.
* automated unit tests. Ha, like I'm gonna be that diligent!
* easily working on ARM in a more uniform way to prepare for the move in to https://github.com/cirosantilli/linux-kernel-module-cheat/tree/87e846fc1f9c57840e143513ebd69c638bd37aa8#baremetal-setup

=== Macros vs functions

Using macros for now on link:common.h[] instead of functions because it simplifies the linker script.

But the downsides are severe:

* no symbols to help debugging. TODO: I think there are assembly constructs for that.
* impossible to step over method calls: you have to step into everything. TODO: `until`?
* larger output, supposing I can get linker gc for unused functions working, see `--gc-section`, which is for now uncertain.
+
If I can get this working, I'll definitely move to function calls.
+
The problem is that if I don't, every image will need a stage 2 loader. That is not too serious though, it could be added to the `BEGIN`.
+
It seems that `ld` can only remove sections, not individual symbols: http://stackoverflow.com/questions/6687630/c-c-gcc-ld-remove-unused-symbols With GCC we can use `-ffunction-sections -fdata-sections` to quickly generate a ton of sections, but I don't thing GAS supports that...

We should just rewrite the whole thing to use functions instead...

==== Macro conventions

Every "function-like macro" in link:common.h[] must maintain the state of general purpose registers.

Flags are currently not maintained.

`%sp` cannot be used to pass most arguments.

We don't care about setting `%bp` properly at the moment.

=== NASM

....
cd nasm/
./run bios_hello_world
....

Source: link:nasm/bios_hello_world.asm[]

While NASM is a bit more convenient than GAS to write a boot sector, I think it is just not worth it.

When writing an OS in C, we are going to use GCC, which already uses GAS. So it's better to reduce the number of assemblers to one and stick to GAS only.

Right now, this directory is not very DRY since NASM is secondary to me, so it contains mostly some copy / paste examples.

On top of that, GAS also supports other architectures besides x86, so learning it is more useful in that sense.

=== Linux is open source

Always try looking into the Linux kernel to find how those CPU capabilities are used in a "real" OS.

=== Pre-requisites

OS dev is one of the most insanely hard programming tasks a person can undertake, and will push your knowledge of several domains to the limit.

Knowing the following will help a lot:

* userland x86 assembly: https://github.com/cirosantilli/assembly-cheat
* compilation, linking and ELF format basics
* GDB debugging

While it is possible to learn those topics as you go along, and it is almost certain that you will end up learning more about them, we will not explain them here in detail.

== Bibliography

=== Intel manual

We are interested mostly in the "Intel Manual Volume 3 System Programming Guide", where system programming basically means "OS stuff" or "bare metal" as opposed to userland present in the other manuals.

This repository quotes by default the following revision: 325384-056US September 2015 https://web.archive.org/web/20151025081259/http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-system-programming-manual-325384.pdf

=== Small educational projects

Fun, educational and useless:

* https://github.com/arjun024/mkeykernel, https://github.com/arjun024/mkernel
+
Worked, but bad build system: not `Makefile` or `.gitignore`.

The following did not work on my machine out of the box:

* https://github.com/apparentlymart/ToyOS
* https://github.com/rde1024/toyos

==== Baremetal games

* https://github.com/programble/bare-metal-tetris tested on Ubuntu 14.04. Just works.
+
Has Multiboot and El Torito. Uses custom linker script.
+
Almost entirely in C `-nostdlib`, with very few inline `asm` commands, and a small assembly entry point. So a good tutorial in how to do the bridge.
* https://github.com/daniel-e/tetros Tetris that fits into bootloader.
* https://github.com/nanochess/fbird Flappy bird in the 512-byte boot sector.
* https://github.com/Overv/MineAssemble Minecraft
* https://github.com/tsoding/pinpog Pong / Breakout
* https://github.com/io12/bootmine Minesweeper game in a 512-byte boot sector.

=== Tutorials

* https://farid.hajji.org/en/blog/46-hello-world-on-the-bare-metal
* https://arobenko.gitbooks.io/bare_metal_cpp/content/

==== Educational NIXes

One complexity order above the minimal tutorials, one below actual kernels

* http://www.xinu.cs.purdue.edu/
* https://pdos.csail.mit.edu/6.828/2014/xv6.html
* https://en.wikipedia.org/wiki/MINIX, influenced Linux
* https://github.com/SerenityOS/serenity

==== Educational non-NIXes

* https://github.com/intermezzOS/book
* https://github.com/flosse/rust-os-comparison

=== Multi collaborator websites

* osdev.org is a major source for this.
** http://wiki.osdev.org/C%2B%2B_Bare_Bones
** http://wiki.osdev.org/Text_UI
** http://wiki.osdev.org/GUI
* http://www.osdever.net/
* https://courses.engr.illinois.edu/ece390/books/labmanual/index.html Illinois course from 2004

=== Progressive tutorials

==== jamesmolloy

http://www.jamesmolloy.co.uk/tutorial_html/index.html

The classic tutorial. Highly recommended.

Multiboot based kernels of increasing complexity, one example builds on the last one. Non DRY as a result.

Cleaned up source code: https://github.com/cirosantilli/jamesmolloy-kernel-development-tutorials

Well known bugs: http://wiki.osdev.org/James_Molloy's_Tutorial_Known_Bugs That's what happens when you don't use GitHub.

Good tutorials, author seems to master the subject.

But he could learn more about version control and build automation: source code inside ugly tar.gz with output files.

==== cfenollosa/os-tutorial

https://github.com/cfenollosa/os-tutorial

Ubuntu 18.04 usage: apply this patch https://github.com/cfenollosa/os-tutorial/pull/100 and then:

....
cd 23-fixes
make run
....

Starts with raw assembly + inludes, moves to C midway.

Raw stage-2 loader. No task scheduling yet, but the feature is... "scheduled" ;-)

Explains how to use the QEMU GDB stub and automates it on makefile, kudos.

Reviewed at: 7aff64740e1e3fba9a64c30c5cead0f88514eb62

==== SamyPesse/How-to-Make-a-Computer-Operating-System

https://github.com/SamyPesse/How-to-Make-a-Computer-Operating-System

Has one big source tree that goes up to multitasking and a stdlib. Kernel written C++ and stdlib in C. TODO check: 64-bit, ring 0 vs ring 3? `git grep rax`  has no hits, so I'm guessing no 64-bit.

Build failed on Ubunbu 18.04 with: https://github.com/SamyPesse/How-to-Make-a-Computer-Operating-System/issues/127 and I didn't bother to investigate.

Does have a `lucid32` Vagrant file for the host, but lazy to try it out.

Reviewed at: eb30f8802fac9f0f1c28d3a96bb3d402bdfc4687

==== Other progressive tutorials

* https://sourceforge.net/p/oszur11/code/ci/master/tree/
+
GitHub mirror: https://github.com/cirosantilli/oszur11-operating-system-examples
+
Several examples of increasing complexity. Found at: http://stackoverflow.com/questions/7130726/writing-a-hello-world-kernel
+
Just works, but examples are non-minimal, lots of code duplication and blobs. There must be around 20 El Torito blobs in that repo.
+
Multiboot based.
* http://www.brokenthorn.com/Resources/OSDevIndex.html
* http://skelix.net/skelixos/index_en.html
+
Cleaned up version: https://github.com/cirosantilli/skelix-os
+
Not tested yet.
+
GAS based, no multiboot used.
* https://github.com/littleosbook/littleosbook

=== Actually useful

These are not meant as learning resources but rather as useful programs:

* https://github.com/scanlime/metalkit A more automated / general bare metal compilation system. Untested, but looks promising.
* Python without an "OS": https://us.pycon.org/2015/schedule/presentation/378/

=== ARM

A list of ARM bare metal resources can be found at: https://github.com/cirosantilli/arm-assembly-cheat/tree/117f5d7d3458c028275ce112725f2e36f594f13c#bare-metal

== LICENSE

Copyright Ciro Santilli https://cirosantilli.com

https://www.gnu.org/licenses/gpl-3.0.txt[GPL v3] for executable computer program usage.

https://creativecommons.org/licenses/by-sa/4.0/[CC BY-SA v4] for human consumption usage in learning material, e.g. `.md` files, source code comments, using source code excerpts in tutorials. Recommended attribution:

* Single file adaptations:
+
....
Based on https://github.com/cirosantilli/x86-bare-metal-examples/blob/<commit-id>/path/to/file.md under CC BY-SA v4
....
* Multi-file adaptations:
+
....
Based on https://github.com/cirosantilli/x86-bare-metal-examples/tree/<commit-id> under CC BY-SA v4
....

If you want to use this work under a different license, contact the copyright owner, and he might make a good price.
