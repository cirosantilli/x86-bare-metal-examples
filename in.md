# in

# out

IO operations.

Do not work with immediates: only registers or memory locations.

## Bit 0x80

TODO http://wiki.osdev.org/CMOS#Getting_Current_Date_and_Time_from_RTC says:

    /* since the 0x80 bit of al is not set, NMI is active */
    out 0x70, al

What does it mean?
