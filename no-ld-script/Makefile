.POSIX:

MAIN := main.img

.PHONY: clean run

$(MAIN): main.S
	as -o main.o '$<'
	ld --oformat binary -o '$@' -Ttext 0x7C00 main.o

clean:
	rm -f '$(MAIN)'

run: $(MAIN)
	qemu-system-i386 -hda '$(MAIN)'
