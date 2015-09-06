/* biosfunc.S -- real-mode BIOS and convenience functions. */

        .file        "biosfunc.S"
        .code16

        /*
         * The following convenience functions are only available
         * in real mode through BIOS:
         *
         * void clrscr()        # clear display
         * void curshome()      # move cursor home (0:0)
         * void puts(%si)       # display string
         * void putc(%al)       # display char
         *
         * use this libary like this:
         *   .include biosfunc.S
         */

/* clrscr() -- clear dislay */
clrscr:
        /*
         * clrscr() clears the video buffer, using a special case in
         * the BIOS function "SCROLL UP WINDOW".  Note that this
         * function is only available in real mode, and that some
         * buggy BIOSes destroy the base pointer %bp, so we better
         * temporarily save it on the stack.
         */
        pushw %bp               # BIOS call below *can* destroy %BP

        movb  $0x06,   %ah      # BIOS function "SCROLL UP WINDOW"
        movb  $0x0,    %al      # nr. of lines to scroll (00=clear window)
        movb  $0x7,    %bh      # attr. to fill new lines at bottom
        movw  $0x0,    %cx      # CH,CL: row,column upper left corner  (00:00)
        movw  $0x184f, %dx      # DH,DL: row,column lower right corner (24:79)
        int   $0x10             # call BIOS

        popw  %bp
        retw

/* curshome() -- set cursor position to 0:0 */
curshome:
        /*
         * curshome() moves the cursor to position 0:0 (top:left),
         * using the BIOS function "SET CURSOR POSITION".  This
         * function is only available in real mode.
         */
        movb $0x02, %ah         # BIOS function "SET CURSOR POSITION"
        movb $0x0,  %bh         # page number 0
        movw $0x0,  %dx         # DH=0 row, DL=0 col
        int  $0x10              # call BIOS
        retw

/* puts(%si) -- display 0-terminated string via putc() */
puts:
        /*
         * puts() repeatedly loads a byte from the buffer pointed
         * to by %si into %al, and displays that byte by calling
         * putc(%al), until a \0-byte is encountered.  The buffer
         * should thus be \0-terminated, like a regular C-string.
         */
        lodsb                   # Load next byte from %si buffer into %al
        cmpb  $0x0, %al         # %al == 0?
        je    puts1             # Yes: end of string!
        callw putc              # No: Display current char
        jmp   puts              # Proceed next char
puts1:  retw

/* putc(%al) -- output char %al via BIOS call int 10h, func 0Eh */
putc:
        /*
         * putc(%al) displays the byte %al on the default video
         * buffer, using the BIOS function "TELETYPE OUTPUT".
         * This function interprets some but not all control
         * characters correctly, but it doesn't matter all too
         * much in this simple example.  This BIOS function is
         * only available in real mode.
         */
        movw  $0x7, %bx            # BH: page 0, BL: attribute 7 (normal white)
        movb  $0xe, %ah            # BIOS function "TELETYPE OUTPUT"
        int   $0x10                # call BIOS
        retw
