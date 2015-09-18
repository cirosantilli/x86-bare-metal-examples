# Bibliography

-   <https://github.com/cirosantilli/assembly-cheat> Information about assembly in general.

-   <http://stackoverflow.com/questions/22054578/run-a-program-without-an-operating-system>

-   <https://github.com/programble/bare-metal-tetris> tested on Ubuntu 14.04. Just works.

    Has Multiboot and El Torito. Uses custom linker script.

    Almost entirely in C `-nostdlib`, with very few inline `asm` commands, and a small assembly entry point. So a good tutorial in how to do the bridge.

-   osdev.org is a major source for this.

    - <http://wiki.osdev.org/C%2B%2B_Bare_Bones>
    - <http://wiki.osdev.org/Text_UI>
    - <http://wiki.osdev.org/GUI>

-   <https://sourceforge.net/p/oszur11/code/ci/master/tree/>

    Several examples of increasing complexity. Found at: <http://stackoverflow.com/questions/7130726/writing-a-hello-world-kernel>

-   <https://github.com/scanlime/metalkit> A more automated / general bare metal compilation system. Untested, but looks promising.

The following did not work on my machine out of the box:

- <https://github.com/apparentlymart/ToyOS>
- <https://github.com/rde1024/toyos>
