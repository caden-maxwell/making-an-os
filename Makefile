# Notes for my own sanity:

# target … : prerequisites …
#        recipe
#        …

# $^ - all the target’s dependencies
# $< - the first dependency
# $@ - the target file
# $? - all dependencies that are newer than the target
# $* - the part of the filename that matched a wildcard
# % - wildcard, matches any string
# "wildcard" - expands to a list of files that match a pattern
# VAR = value - defines a variable
# $(VAR) - expands to the value of the variable

# Automatically expand to a list of existing files that
# match the patterns
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

# Create a list of object files to build by replacing
# the `.c` extension with `.o` for files in C_SOURCES.
OBJS = $(C_SOURCES:.c=.o)

# default for `make`, since it's the first rule
.PHONY: all
all: os-image

# Runs qemu with hard disk
.PHONY: run
run: all
	qemu-system-x86_64 -drive format=raw,file=os-image

# Runs qemu with floppy disk
.PHONY: runf
runf: all
	qemu-system-x86_64 -drive file=os-image,if=floppy,index=0,media=disk,format=raw

os-image: boot/boot.bin kernel.bin
	cat $^ > $@

kernel.bin: kernel/enter_kernel.o ${OBJS}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

%.o: %.c ${HEADERS}
	gcc -ffreestanding -c -o $@ $< 

%.o: %.asm
	nasm -O0 -f elf64 -s -o $@ $<

%.bin: %.asm
	nasm -O0 -f bin -o $@ $<

.PHONY: disasm
disasm: kernel.dis
kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

.PHONY: clean
clean:
	rm -f *.bin *.dis *.o os-image
	rm -f boot/*.bin kernel/*.o drivers/*.o

.PHONY: rerun
rerun: clean run
