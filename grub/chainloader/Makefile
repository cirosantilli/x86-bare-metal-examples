.POSIX:

.PHONY: clean run

main.img:
	make -C '../mbrs' && cp '../bios_hello_world.img.sym' 'iso/boot/main.img'
	grub-mkrescue -o '$@' iso

clean:
	rm -f iso/boot/*.img *.img

run: main.img
	qemu-system-i386 -drive 'file=$<,format=raw'
