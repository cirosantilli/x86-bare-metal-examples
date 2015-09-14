# IO

You cannot use any libraries, so how to do IO? Some ways that this can be done:

- BIOS functions: <http://wiki.osdev.org/BIOS>. Not well standardized like it's successor UEFI. Called through interrupts.
- <https://en.wikipedia.org/wiki/VGA-compatible_text_mode>
- VBE <https://en.wikipedia.org/wiki/VESA_BIOS_Extensions>

Showdown and restart can be managed with either:

-   ACPI <https://en.wikipedia.org/wiki/Advanced_Configuration_and_Power_Interface>

    Newer and better.

    Now managed by the same group that manages UEFI.

    Spec:

    - current: <http://uefi.org/specifications>
    - old: <http://www.uefi.org/acpi/specs>

-   APM <https://en.wikipedia.org/wiki/Advanced_Power_Management>

    <http://wiki.osdev.org/APM>

    Older and simpler.

    By Microsoft in 1995. Spec seems to be in RTF format...

See also: <http://wiki.osdev.org/Shutdown>
