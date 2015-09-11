.POSIX:

BIN := isodir/boot/main.bin
MAIN := main.iso

.PHONY: clean run

$(MAIN):
	as -32 boot.S -o boot.o
	gcc -c kernel.c -ffreestanding -m32 -o kernel.o -std=gnu99
	gcc -ffreestanding -m32 -nostdlib -o '$(BIN)' -T linker.ld boot.o kernel.o -lgcc
	grub-mkrescue -o main.iso isodir

clean:
	rm -f *.o '$(BIN)' '$(MAIN)'

run: $(MAIN)
	qemu-system-i386 -cdrom '$(MAIN)'
	# Would also work.
	#qemu-system-i386 -kernel myos.bin
