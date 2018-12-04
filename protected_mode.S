/* https://github.com/cirosantilli/x86-bare-metal-examples# */

#include "common.h"
BEGIN
    CLEAR
    PROTECTED_MODE
    VGA_PRINT_STRING $message
    jmp .
message:
    .asciz "hello world"
