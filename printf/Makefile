.POSIX:

MAIN := main.img

.PHONY: clean run

$(MAIN):
	rm -f $(MAIN)
	# hlt instruction.
	printf '\364' >> '$(MAIN)'
	printf '%509s' >> '$(MAIN)'
	# Mandatory magic bytes 511 and 512 of a boot sector.
	printf '\125\252' >> '$(MAIN)'

clean:
	rm -f '$(MAIN)'

run: $(MAIN)
	qemu-system-i386 -drive file='$(MAIN)',format=raw
