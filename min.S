/* https://github.com/cirosantilli/x86-bare-metal-examples#minimal-gas-example */

/* Tell GAS to generate 16 bit code. */
.code16

/* Don't listen to interrupts. */
cli

/* Zero ds.
 *
 * This is only needed if we are going to access memory.
 *
 * The program might work on QEMU without this, but fail on real hardware:
 * http://stackoverflow.com/questions/32508919/how-to-produce-a-minimal-bios-hello-world-boot-sector-with-gcc-that-works-from-a
 *
 * You cannot write immediates directly to it, must pass through ax:
 * http://stackoverflow.com/questions/19074666/8086-why-cant-we-move-an-immediate-data-into-segment-register
 */
xor %ax, %ax
mov %ax, %ds

/* Stop the processor. */
hlt
