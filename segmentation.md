# Segmentation

This is about protected mode segmentation, which coverts liner to global addresses.

## GDT

Table in memory that gives properties of segment registers.

Segment registers in protected mode point to entries of that table.

GDT is used as soon as we enter protected mode, so that's why we have to deal with it, but the preferred way of managing program memory spaces is paging.

Format:

- Intel Manual 325384-053US Volume 3, 3.4.5 Segment Descriptors
- https://en.wikipedia.org/wiki/Global_Descriptor_Table
- http://wiki.osdev.org/GDT

    +-------------------------------------------------+
    | segment address 24-31  | flags #2  | len 16-19  |
    +-------------------------------------------------+
    | flags #1               | segment address 16-23  |
    +-------------------------------------------------+
    | segment address bits 0-15                       |
    +-------------------------------------------------+
    | segment length bits 0-15                        |
    +-------------------------------------------------+

### Null segment selector

### Null descriptor

Intel manual 3.4.2 Segment Selectors says:

> The first entry of the GDT is not used by the processor. A segment selector that points to this entry of the GDT (that
is, a segment selector with an index of 0 and the TI flag set to 0) is used as a “null segment selector.” The processor
does not generate an exception when a segment register (other than the CS or SS registers) is loaded with a null
selector. It does, however, generate an exception when a segment register holding a null selector is used to access
memory. A null selector can be used to initialize unused segment registers. Loading the CS or SS register with a null
segment selector causes a general-protection exception (#GP) to be generated.

### Effect on memory access

The GDT modifies every memory access of a given segment by:

- adding an offset to it
- limiting how big the segment is

If an access is made at an offset larger than allowed: TODO some exception happens, which is like an interrupt, and gets handled by a previously registered handler.

The GDT could be used to implement virtual memory by using one segment per program:

    +-----------+--------+--------------------------+
    | Program 1 | Unused | Program 2                |
    +-----------+--------+--------------------------+
    ^           ^        ^                          ^
    |           |        |                          |
    Start1      End1     Start2                     End2

The problem with that is that each program must have one segment, so if we have too many programs, fragmentation will be very large.

Paging gets around this by allowing discontinuous memory ranges of fixed size for each program.

The format of the GDT is given at: http://wiki.osdev.org/Global_Descriptor_Table

### Effect on permissions

Besides fixing segment sizes, the GDT also specifies permissions to the program that is running:

-   ring level: limits several things that can or not be done, in particular:
    - instructions: e.g. no in / out in ring 3
    - register access: e.g. cannot modify control registers like the GDTR in ring 3. Otherwise user programs could just escape restrictions by changing that!
-   executable, readable and writable bits: which operations can be done

## GDTR

## GDT register

In 32-bit, a 6 byte register that holds:

- 2 byte length of the GDT (TODO in bytes or number of entries?)
- 4 byte address of the GDT in memory

In 64 bit, makes 10 bytes, with the address having 8 bytes

GRUB seems to setup one for you: http://www.jamesmolloy.co.uk/tutorial_html/4.-The%20GDT%20and%20IDT.html
