.POSIX:

.PHONY: clean run

BZIMAGE := iso/boot/bzImage

main.img: $(BZIMAGE)
	grub-mkrescue -o '$@' iso

$(BZIMAGE):
	wget https://github.com/cirosantilli/linux-kernel-module-cheat/releases/download/uploads/images-ab21ef58deed8536bc159c2afd680a4fabd68510.zip
	unzip images-*.zip
	cp out/x86_64/buildroot/images/bzImage '$@'

clean:
	rm -f iso/boot/*.img *.img

run: main.img
	qemu-system-i386 -drive 'file=$<,format=raw'
