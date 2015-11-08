.POSIX:

COMMON ?= common.h
LD ?= ld
LINKER_SCRIPT ?= linker.ld
# Use gcc so that the preprocessor will run first.
GAS ?= gcc
GAS_EXT ?= .S
NASM_EXT ?= .asm
OBJ_EXT ?= .o
OUT_EXT ?= .img
QEMU ?= qemu-system-i386
RUN ?= bios_hello_world
TMP_EXT ?= .tmp

OUTS := $(foreach IN_EXT,$(NASM_EXT) $(GAS_EXT),$(patsubst %$(IN_EXT),%$(OUT_EXT),$(wildcard *$(IN_EXT))))
RUN_FILE := $(RUN)$(OUT_EXT)

.PRECIOUS: %$(OBJ_EXT)
.PHONY: all clean run

all: $(OUTS)

%$(OUT_EXT): %$(OBJ_EXT) $(LINKER_SCRIPT)
	@# Failed attempt at getting debug symbols.
	@#$(LD) -melf_i386 -o '$(@:$(OUT_EXT)=.elf)' -T '$(LINKER_SCRIPT)' '$<'
	$(LD) --oformat binary -o '$@' -T '$(LINKER_SCRIPT)' '$<'

%$(OBJ_EXT): %$(GAS_EXT) $(COMMON)
	$(GAS) -c -g -o '$@' '$<'

%$(OUT_EXT): %$(NASM_EXT)
	nasm -f bin -o '$@' '$<'

# So that directories without a common.h can reuse this.
$(COMMON):

clean:
	rm -fr *$(OBJ_EXT) *$(OUT_EXT) *$(TMP_EXT)

run: all
	$(QEMU) -drive 'file=$(RUN_FILE),format=raw' -smp 2

debug: all
	$(QEMU) -hda '$(RUN_FILE)' -S -s &
	gdb -x gdb.gdb

bochs: all
	# Supposes size is already multiples of 512.
	# We force that with our linker script,
	# and `grub-mkrescue` also seems to respect it as well.
	CYLINDERS="$$(($$(stat -c '%s' '$(RUN_FILE)') / 512))" && \
	bochs -qf /dev/null \
		'ata0-master: type=disk, path="$(RUN_FILE)", mode=flat, cylinders='"$$CYLINDERS"', heads=1, spt=1' \
		'boot: disk' \
		'display_library: sdl' \
		'megs: 128'

BIG_IMG_DIR := big_img$(TMP_EXT)
BOOT_DIR := $(BIG_IMG_DIR)/boot
GRUB_DIR := $(BOOT_DIR)/grub
big-img: all
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
	grub-mkrescue -o 'big.img' '$(BIG_IMG_DIR)'
