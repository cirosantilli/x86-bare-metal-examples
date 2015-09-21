/*
http://stackoverflow.com/questions/32682152/how-to-reboot-in-x86-assembly-from-16-bit-real-mode

Infinite reboot loop on emulator!

TODO why does it work?
*/

#include "common.h"
BEGIN
ljmpw $0xF000, $0XFFF0
END
