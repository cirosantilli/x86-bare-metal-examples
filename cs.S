/* https://github.com/cirosantilli/x86-bare-metal-examples#cs */

#include "common.h"
BEGIN
    CLEAR

    mov %cs, %ax
    PRINT_HEX <%al>
    PRINT_NEWLINE

    /* CS = 1 */
    ljmp $1, $1f
    1:
    .skip 0x10
    mov %cs, %ax
    PRINT_HEX <%al>
    PRINT_NEWLINE

    /* CS = 2 */
    ljmp $2, $1f
    1:
    .skip 0x20
    mov %cs, %ax
    PRINT_HEX <%al>
    PRINT_NEWLINE

    hlt
