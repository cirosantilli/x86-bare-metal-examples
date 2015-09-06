# Print a single `@` character with the BIOS.
# More minimal than the hello world.
#include "common.h"
BEGIN
cli
mov $0x40, %al
mov $0x0e, %ah
int $0x10
hlt
END
