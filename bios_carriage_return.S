/* https://github.com/cirosantilli/x86-bare-metal-examples#bios-examples */

#include "common.h"
BEGIN
    PRINT_STRING $msg
    hlt
msg:
    .asciz "hello\n\rworld"
