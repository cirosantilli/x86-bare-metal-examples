.POSIX:

RUN ?= bios_hello_world
IN_EXT ?= .asm
OUT_EXT ?= .img

OUTS := $(patsubst %$(IN_EXT),%$(OUT_EXT),$(wildcard *$(IN_EXT)))
RUN_FILE := $(RUN)$(OUT_EXT)

.PHONY: clean run

all: $(OUTS)

%$(OUT_EXT): %$(IN_EXT)
	nasm -f bin -o '$@' '$<'

clean:
	rm -f *'$(OUT_EXT)'

run: all
	qemu-system-i386 '$(RUN_FILE)'

bochs: all
	CYLINDERS="$$(($$(stat -c '%s' '$(RUN_FILE)') / 512))" && \
	bochs -qf /dev/null \
		'ata0-master: type=disk, path="$(RUN_FILE)", mode=flat, cylinders='"$$CYLINDERS"', heads=1, spt=1' \
		'boot: disk' \
		'display_library: sdl' \
		'megs: 128'
