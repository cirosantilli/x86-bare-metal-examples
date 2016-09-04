# Ring

IA-32 implements a hardware protection privilege system.

Rings are implemented together with the segmentation system.

There are in total 4 privilege levels, also called rings, from 0 to 3, 0 being the one with the highest privilege.

Most operating systems use only 2: kernel space and user space, usually with values 0 and 3. This is the case for Linux.

For each ring, a certain set of operations is allowed by the processor.

Rings are useful for OS programmers. The OS lets user programs run a restricted set of operations limiting the amount of damage that a badly working or badly intentioned program can do. Obviously this only works because user programs are then in a state in which they cannot modify their own privilege levels without the OS intervening.

Certain operations such are only allowed if certain privileges are given.

Privilege control is only available on protected mode, and is managed by segmentation and paging.

## Negative rings

TODO: officially documented, possibly with other names?

- <https://en.wikipedia.org/wiki/Popek_and_Goldberg_virtualization_requirements>
- <https://www.quora.com/Computer-Science-What-does-In-x86-beyond-ring-0-lie-the-more-privileged-realms-of-execution-where-our-code-is-invisible-to-AV-we-have-unfettered-access-to-hardware-and-can-trivially-preempt-and-modify-the-OS-mean>

Some of them were introduced to satisfy <https://en.wikipedia.org/wiki/Popek_and_Goldberg_virtualization_requirements>
