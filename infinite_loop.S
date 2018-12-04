/* https://github.com/cirosantilli/x86-bare-metal-examples#infinite-loop */

#include "common.h"
BEGIN
loop:
jmp loop
