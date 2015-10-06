.POSIX:

ASM_EXT ?= .asm
S_EXT ?= .S
LD ?= ld
LINKER_SCRIPT ?= linker.ld
# Use gcc so that the preprocessor will run first.
GAS ?= gcc
OBJ_EXT ?= .o
OUT_EXT ?= .img
QEMU ?= qemu-system-i386
RUN ?= bios_hello_world
TMP_EXT ?= .tmp

OUTS := $(foreach IN_EXT,$(ASM_EXT) $(S_EXT),$(patsubst %$(IN_EXT),%$(OUT_EXT),$(wildcard *$(IN_EXT))))
RUN_FILE := $(RUN)$(OUT_EXT)

.PRECIOUS: %$(OBJ_EXT)
.PHONY: all clean run

all: $(OUTS)

%$(OUT_EXT): %$(OBJ_EXT) $(LINKER_SCRIPT)
	$(LD) --oformat binary -o '$@' -T '$(LINKER_SCRIPT)' '$<'

%$(OBJ_EXT): %$(S_EXT)
	$(GAS) -c -o '$@' '$<'

%$(OUT_EXT): %$(ASM_EXT)
	nasm -f bin -o '$@' '$<'

clean:
	rm -fr *$(OBJ_EXT) *$(OUT_EXT) *$(TMP_EXT)

run: all
	$(QEMU) '$(RUN_FILE)'

debug: all
	$(QEMU) -hda '$(RUN_FILE)' -S -s &
	gdb -ex 'target remote localhost:1234' -ex 'break *0x7c00' -ex 'continue'

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
