.POSIX:

COMMON ?= common.h
DOC_OUT = README.html
ELF_EXT = .elf
LD ?= ld
LINKER_SCRIPT ?= linker.ld
# Use gcc so that the preprocessor will run first.
GAS ?= gcc
GAS_EXT ?= .S
NASM_EXT ?= .asm
OBJ_EXT ?= .o
OUT_EXT ?= .img
QEMU ?= qemu-system-i386 -drive 'file=$(RUN_FILE),format=raw' -serial mon:stdio -smp 2
RUN ?= bios_hello_world
RUN_ARGS ?= -soundhw pcspk
TMP_EXT ?= .tmp

OUTS := $(sort $(foreach IN_EXT,$(NASM_EXT) $(GAS_EXT),$(patsubst %$(IN_EXT),%$(OUT_EXT),$(wildcard *$(IN_EXT)))))
RUN_FILE := $(RUN)$(OUT_EXT)

.PRECIOUS: %$(OBJ_EXT)
.PHONY: all clean doc run

all: $(OUTS)

%$(OUT_EXT): %$(OBJ_EXT) $(LINKER_SCRIPT)
	$(LD) -melf_i386  -nostdlib -o '$(@:$(OUT_EXT)=$(ELF_EXT))' -T '$(LINKER_SCRIPT)' '$<'
	objcopy -O binary '$(@:$(OUT_EXT)=.elf)' '$@'

%$(OBJ_EXT): %$(GAS_EXT) $(COMMON)
	$(GAS) -m32 -c -ggdb3 -o '$@' '$<'

%$(OUT_EXT): %$(NASM_EXT)
	nasm -f bin -o '$@' '$<'

# So that directories without a common.h can reuse this.
$(COMMON):

clean:
	rm -fr '$(DOC_OUT)' *$(ELF_EXT) *$(OBJ_EXT) *$(OUT_EXT) *$(TMP_EXT)

run: $(RUN_FILE)
	$(QEMU) $(RUN_ARGS)

debug: $(RUN_FILE)
	$(QEMU) -S -s &
	gdb -quiet -x gdb.gdb '$(<:$(OUT_EXT)=$(ELF_EXT))'

bochs: $(RUN_FILE)
	# Supposes size is already multiples of 512.
	# We force that with our linker script,
	# and `grub-mkrescue` also seems to respect it as well.
	CYLINDERS="$$(($$(stat -c '%s' '$(RUN_FILE)') / 512))" && \
	bochs -qf /dev/null \
		'ata0-master: type=disk, path="$(RUN_FILE)", mode=flat, cylinders='"$$CYLINDERS"', heads=1, spt=1' \
		'com1: enabled=1, mode=file, dev=$(RUN).tmp.serial' \
		'boot: disk' \
		'display_library: sdl2' \
		'megs: 128'

BIG_IMG_DIR := big_img$(TMP_EXT)
BOOT_DIR := $(BIG_IMG_DIR)/boot
GRUB_DIR := $(BOOT_DIR)/grub
big$(OUT_EXT): all
	rm -rf '$(BIG_IMG_DIR)'
	mkdir -p  '$(GRUB_DIR)'
	for out in $(OUTS); do\
	  printf "menuentry \"$${out%.*}\"  {\n   chainloader /boot/$$out\n}\n" >> '$(GRUB_DIR)/grub.cfg';\
	  cp "$$out" '$(BOOT_DIR)';\
	done
	# TODO why does this fail to boot properly?
	#make -C multiboot/hello-world
	#mkdir -p '$(BOOT_DIR)/multiboot'
	#printf "menuentry \"multiboot/hello-world\"  {\n   chainloader /boot/multiboot/hello-world.img\n}\n" >> '$(GRUB_DIR)/grub.cfg';\
	#cp multiboot/hello-world/main.img '$(BOOT_DIR)/multiboot/hello-world.img'
	grub-mkrescue -o '$@' '$(BIG_IMG_DIR)'

doc: $(DOC_OUT)

$(DOC_OUT): README.adoc
	asciidoctor -o $@ -v $<
