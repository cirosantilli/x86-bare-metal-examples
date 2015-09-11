.POSIX:

IN_EXT ?= .S
LD ?= ld
LINKER_SCRIPT ?= linker.ld
# Use gcc so that the preprocessor will run first.
MYAS ?= gcc
OBJ_EXT ?= .o
OUT_EXT ?= .img
RUN ?= bios_hello_world

INS := $(wildcard *$(IN_EXT))
OUTS := $(patsubst %$(IN_EXT),%$(OUT_EXT),$(INS))

.PRECIOUS: %$(OBJ_EXT)
.PHONY: all clean run

all: $(OUTS)

%$(OUT_EXT): %$(OBJ_EXT) $(LINKER_SCRIPT)
	$(LD) --oformat binary -o '$@' '$<' -T '$(LINKER_SCRIPT)' #-Ttext 0x7C00

%$(OBJ_EXT): %$(IN_EXT)
	$(MYAS) -c -o '$@' '$<'

clean:
	rm -f *$(OBJ_EXT) *$(OUT_EXT)

run: all
	qemu-system-i386 '$(RUN)$(OUT_EXT)'
