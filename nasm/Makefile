.POSIX:

BASENAME ?= bios_hello_world
IN_EXT ?= .asm
OUT_EXT ?= .bin

OUT := $(BASENAME)$(OUT_EXT)

.PHONY: clean run

$(OUT): $(BASENAME)$(IN_EXT)
	nasm -f bin -o '$@' '$<'

clean:
	rm -f '$(OUT)'

run: $(OUT)
	qemu-system-i386 '$(OUT)'
