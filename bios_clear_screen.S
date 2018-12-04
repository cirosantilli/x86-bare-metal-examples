/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-clear-screen */

#include "common.h"
BEGIN

/* Print one 'a' char to ensure that something will be cleared.
 *
 * On some systems, BIOS messages get automatically cleared. Not the case for QEMU 2.0.0.
 * */
PUTC $'a

/* Scroll 0 is magic, and scrolls the entire selected rectangle. */
mov $0x0600, %ax
mov $0xA4, %bh

/* Pick the entire screen.
 * Bottom right is at (24,79) == (0x18,0x4F),
 * since we are on the default mode.
 */
mov $0x0000, %cx
mov $0X184F, %dx

int $0x10

/* Print a 'b' char to see where we are now.
 *
 * TODO, on ThinkPad T400, the cursor gets put back to the initial position. But QEMU 2.0.0 leaves it in the middle ofthe screen. Thus we reset the position to make them work the same way.
 */
CURSOR_POSITION
PUTC $'b

hlt
