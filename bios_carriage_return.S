#include "common.h"
BEGIN
    PRINT_STRING $msg
    hlt
msg:
    .asciz "hello\n\rworld"
