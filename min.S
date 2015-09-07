/* Minimal example that does nothing, just halts. */

/* Tell GAS to generate 16 bit code. */
.code16

/* Don't listen to interrupts. */
cli

/* Stop the processor. */
hlt
