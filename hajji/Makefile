RUN = hello.img
INC = biosfunc.S

all: $(INC) $(RUN)

$(RUN): hello.o
	ld -N -e start -Ttext 0x7c00 --oformat binary -o $(RUN) hello.o

hello.o: hello.S $(INC)
	as -o hello.o hello.S

disassemble: $(RUN)
	objdump --disassemble-all --target=binary --architecture=i8086 $(RUN)

run: $(RUN)
	qemu-system-i386 -hda $(RUN)

clean:
	rm -f *.o a.out $(RUN)
