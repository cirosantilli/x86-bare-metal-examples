# Modes of operation

Covered on Intel Volume 3. Specially useful is the "Transitions Among the Processor’s Operating Modes" diagram.

-   Protected
-   Real address
-   System management
-   IA-32e. Has two sub modes:
    - Compatibility
    - 64-bit

## Real mode

CPU starts here for backwards compatibility.

<http://wiki.osdev.org/Real_Mode>

It is possible to use 32-bit registers in this mode with the "Operand Size Override Prefix" `0x66`.

TODO: is it possible to access memory above 1M like this:

    mov $1, 0xF0000000
    mov $1, (%eax)

<http://stackoverflow.com/questions/6917503/is-it-possible-to-use-32-bits-registers-instructions-in-real-mode>

## IA-32e

Wikipedia seems to call it *long mode*: <https://en.wikipedia.org/wiki/Long_mode>

Contains two sub-modes: 64-bit and compatibility.

64-bit is the major mode of operation, compatibility mode emulates IA-32. This is where systems run most of the time.

The other mode is legacy mode, which as the name implies, should not be used on new programs.

### Compatibility mode

Controlled by the `CS.L` bit of the segment descriptor.

It appears that it is possible for user programs to modify that during execution: <http://stackoverflow.com/questions/12716419/can-you-enter-x64-32-bit-long-compatibility-sub-mode-outside-of-kernel-mode>

<http://stackoverflow.com/questions/27868394/switch-from-64-bit-long-mode-to-32-bit-compatibility-mode-on-x64>
