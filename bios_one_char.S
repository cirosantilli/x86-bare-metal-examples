# Print a single `@` character with the BIOS.
# More minimal than the hello world.
.code16
cli
mov $0x40, %al
mov $0x0e, %ah
int $0x10
hlt
.org 510
.word 0xaa55
