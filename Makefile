.POSIX:

IN_EXT ?= .S
LD ?= ld
LINKER_SCRIPT ?= linker.ld
# Use gcc so that the preprocessor will run first.
MYAS ?= gcc
OBJ_EXT ?= .o
OUT_EXT ?= .img
RUN ?= bios_hello_world
TMP_EXT ?= .tmp

INS := $(wildcard *$(IN_EXT))
OUTS := $(patsubst %$(IN_EXT),%$(OUT_EXT),$(INS))

.PRECIOUS: %$(OBJ_EXT)
.PHONY: all clean run

all: $(OUTS)

%$(OUT_EXT): %$(OBJ_EXT) $(LINKER_SCRIPT)
	$(LD) --oformat binary -o '$@' -T '$(LINKER_SCRIPT)' '$<'

%$(OBJ_EXT): %$(IN_EXT)
	$(MYAS) -c -o '$@' '$<'

clean:
	rm -fr *$(OBJ_EXT) *$(OUT_EXT) *$(TMP_EXT)

run: all
	qemu-system-i386 '$(RUN)$(OUT_EXT)'

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
