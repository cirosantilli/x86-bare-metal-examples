/* hello.S -- Hello, World on bare metal, just after BIOS boot. x86 */

        .file "hello.S"

        /*
         * A couple of constants.
         *
         * These can't be changed, because they are set by the
         * firmware (BIOS).
         */
        .set LOAD,      0x7c00     # BIOS loads and jumps here
        .set MAGIC,     0xaa55     # Must be at the end of the 512-byte block
        .set BLOCKSIZE, 512        # Boot block is BLOCKSIZE bytes long

        /*
         * The .text section contains the opcodes (code) for our
         * program.
         */
        .section .text             # This is a code (text) section.
        .code16                    # Boot code runs in 16-bit real mode
        .globl start               # Entry point is public, for the linker.
start:
        /*
         * The processor starts in real mode and executes the first
         * instruction at address $0xFFFF:FFF0.  System designers
         * usually map BIOS at this address, so the CPU starts running
         * BIOS code.  The BIOS initializes RAM and other components.
         * Then, it loads $BLOCKSIZE bytes from the first boot device
         * in RAM, starting at address $0x0:$LOAD.
         *
         * If that block finishes with the $MAGIC sequence 0x55, 0xaa
         * (it is reversed, because IA-32 arch is little endian), BIOS
         * considers this block a valid boot block, and jumps right here.
         */

        /*
         * Initialize segment descriptors %ds, %es, and %ss to 0x0.
         * %cs:%ip is already set by the BIOS to 0x0:$LOAD.
         */
        xorw %ax, %ax
        movw %ax, %es
        movw %ax, %ds

        /*
         * Initialize the stack.
         *
         * Since the stack on x86 grows towards *lower* addresses,
         * we anchor it at $LOAD.  Note that we don't collide with
         * the code because the stack will always remain below
         * (i.e. less than) $LOAD and grows downwards from there.
         * disable intterupts when setting up the stack. If an
         * interrupt occurs between the two MOVs then the stack
         * may point at the wrong memory location and the interrupt
         * may crash the system
         */
        cli
        movw %ax, %ss
        movw $LOAD, %sp
        sti

        /*
         * This is the "main" program:
         *
         * Clear screen, move cursor to the top:left,
         * and display a friendly greetings.
         */
        callw clrscr                  # clear screen
        callw curshome                # move cursor home - top:left
        callw greeting                # display a greeting string
		cli

        /*
         * That's all, folks!
         *
         * We could run a tight loop here, but it's better to halt
         * the processor.  When run on bare metal, a halted processor
         * consumes less power (especially useful if ran on battery).
         * When run under an emulator, the emulator doesn't consume
         * further CPU cycles. Turn off interrupts before caling HLT
         * because execution will only HLT until the next intterupt
         * occurs. Once an interrupt occurs execution continues at
         * the next instruction after HLT
         */
        cli
        hlt

/* greeting() -- display a little message. */
greeting:
        /*
         * greeting dislays the string located at label msg,
         * using the convenience function puts() defined below.
         * We pass the *address* of that string (thus $msg instead
         * of msg) in the %si register.
         */
        movw  $msg, %si
        callw puts
        retw

        /*
         * Finally, include the BIOS convenience functions used above.
         */

        .include "biosfunc.S"             # BIOS convenience functions.
        .file    "hello.S"

/* msg: the string buffer to be displayed. */
msg:
        .asciz "Hello, World!\r\n"        # must be \0-terminated!

        /*
         * The boot block MUST end with a MAGIC sequence.
         *
         * The BIOS checks this, and would refuse to boot unless
         * MAGIC is there.  The last two bytes of the BLOCKSIZE
         * long block must contain the magic sequence 0x55, 0xaa.
         * We move the assembler pointer .org there, and emit the
         * word MAGIC.  Note that MAGIC is set to 0xaa55, and not
         * 0x55aa, because the IA-32 platform is little endian.
         */
        .org BLOCKSIZE - 2
        .word MAGIC
