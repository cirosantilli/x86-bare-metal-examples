# Bibliography

-   <https://github.com/cirosantilli/assembly-cheat> Information about assembly in general.

    README.md explain `make qemu`

-   <http://stackoverflow.com/questions/22054578/run-a-program-without-an-operating-system>

## Small projects

-   <https://github.com/programble/bare-metal-tetris> tested on Ubuntu 14.04. Just works.

    Has Multiboot and El Torito. Uses custom linker script.

    Almost entirely in C `-nostdlib`, with very few inline `asm` commands, and a small assembly entry point. So a good tutorial in how to do the bridge.

The following did not work on my machine out of the box:

- <https://github.com/apparentlymart/ToyOS>
- <https://github.com/rde1024/toyos>

## Multi collaborator websites

-   osdev.org is a major source for this.

    - <http://wiki.osdev.org/C%2B%2B_Bare_Bones>
    - <http://wiki.osdev.org/Text_UI>
    - <http://wiki.osdev.org/GUI>

-   <http://www.osdever.net/>

-   <https://courses.engr.illinois.edu/ece390/books/labmanual/index.html> Illinois course from 2004

## Progressive tutorials

-   <http://www.jamesmolloy.co.uk/tutorial_html/index.html>

    Multiboot based kernels of increasing complexity, one example builds on the last one. Non DRY as a result.

    Source code: <https://github.com/cirosantilli/jamesmolloy-kernel-development-tutorials>

    Well known bugs: <http://wiki.osdev.org/James_Molloy's_Tutorial_Known_Bugs> That's what happens when you don't use GitHub.

    Good tutorials, author seems to master the subject.

    But he could learn more about version control and build automation: source code inside ugly tar.gz with output files.

-   <https://sourceforge.net/p/oszur11/code/ci/master/tree/>

    GitHub mirror: <https://github.com/cirosantilli/oszur11-operating-system-examples>

    Several examples of increasing complexity. Found at: <http://stackoverflow.com/questions/7130726/writing-a-hello-world-kernel>

    Just works, but examples are non-minimal, lots of code duplication and blobs. There must be around 20 El Torito blobs in that repo.

-   <https://github.com/SamyPesse/How-to-Make-a-Computer-Operating-System>

-   <http://www.brokenthorn.com/Resources/OSDevIndex.html>

-   <http://skelix.net/skelixos/index_en.html>

    Cleaned up version: <https://github.com/cirosantilli/skelix-os>

    Not tested yet.

    GAS based, no GRUB needed.

## Actually useful

These are not meant as learning resources but rather as useful programs:

-   <https://github.com/scanlime/metalkit> A more automated / general bare metal compilation system. Untested, but looks promising.

## Other archs

For when we decide to port this tutorial:

ARM:

- <https://github.com/bravegnu/gnu-eprog>

Raspberry PI:

- <https://github.com/dwelch67/raspberrypi>
