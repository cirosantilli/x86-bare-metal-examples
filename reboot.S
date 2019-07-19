/* https://github.com/cirosantilli/x86-bare-metal-examples#reboot */

#include "common.h"
BEGIN
ljmpw $0xF000, $0XFFF0
