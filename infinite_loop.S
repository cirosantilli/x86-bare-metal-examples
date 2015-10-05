/*
This is a common alternative to `hlt`.

It likely wastes more energy? But is less prone to being interrupted than `hlt`.
*/

#include "common.h"
BEGIN
loop:
jmp loop
