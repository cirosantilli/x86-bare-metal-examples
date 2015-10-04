# in

# out

IO operations.

Do not work with immediates: only registers or memory locations.

## Memory mapped vs Port mapped IO

<http://superuser.com/questions/703695/difference-between-port-mapped-and-memory-mapped-access>

`in` and `out` are used for port mapped IO.

In memory mapped IO, IO is done just like RAM IO.

TODO: see some circuit schematics.

## Bit 0x80

TODO http://wiki.osdev.org/CMOS#Getting_Current_Date_and_Time_from_RTC says:

    /* since the 0x80 bit of al is not set, NMI is active */
    out 0x70, al

What does it mean?

## Linux kernel

    man outb
