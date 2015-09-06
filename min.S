/* Minimal example that does nothing, just halts. */

/* Tell GAS to generate 16 bit code. */
.code16

/* Don't listen to interrupts. */
cli

/* Stop the processor. */
hlt

/* Mandatory magic bytes 511 and 512. */
.org 510
.word 0xaa55
