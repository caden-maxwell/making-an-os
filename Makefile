# $^ - all the target’s dependencies
# $< - the first dependency
# $@ - the target file

# Automatically expand to a list of existing files that
# match the patterns
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

# Create a list of object files to build by replacing
# the `.c` extension with `.o` for files in C_SOURCES.
OBJ = ${C_SOURCES:.c=.o}

# default for `make`
all: os-image

# Runs qemu with hard disk
run: all
	qemu-system-x86_64 -drive format=raw,file=os-image

# Runs qemu with floppy disk
runf: all
	qemu-system-x86_64 -drive file=os-image,if=floppy,index=0,media=disk,format=raw

os-image: boot/boot.bin kernel.bin
	cat $^ > os-image

kernel.bin: kernel/enter_kernel.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

%.o: %.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@

%.o: %.asm
	nasm -f elf64 -s -o $@ $<

%.bin: %.asm
	nasm -f bin -o $@ $< 

kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@
	head -n 20 $@

clean:
	rm -f *.bin *.dis *.o os-image
	rm -f boot/*.bin kernel/*.o drivers/*.o

# objcopy -O binary -j .text kernel/kernel.o kernel/kernel.bin
