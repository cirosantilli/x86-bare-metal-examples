/*
What happens when a newline is output with bios.

Outcome:

    hello
         world

Carriage returns are needed just like in old days.
*/

#include "common.h"
BEGIN
    PRINT_STRING $msg
    hlt
msg:
    .asciz "hello\nworld"
