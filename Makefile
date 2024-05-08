# $^ - all the target’s dependencies
# $< - the first dependency
# $@ - the target file

# default for `make`
all: os-image.bin

# Runs qemu with hard disk
run: all
	qemu-system-x86_64 -drive format=raw,file=os-image.bin

# Runs qemu with floppy disk
runf: all
	qemu-system-x86_64 -drive file=os-image.bin,if=floppy,index=0,media=disk,format=raw

os-image.bin: boot/boot.bin kernel/kernel.bin
	cat $^ > os-image.bin

kernel/kernel.bin: kernel/enter_kernel.o kernel/kernel.o
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.o: kernel.c
	gcc -ffreestanding -c $< -o $@

kernel/enter_kernel.o: kernel/enter_kernel.asm
	nasm -f elf64 -s -o $@ $<

boot/boot.bin: boot/boot.asm
	nasm -f bin -o $@ $< 

clean:
	rm *.bin *.o *.dis boot/*.bin

kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@


# objcopy -O binary -j .text kernel/kernel.o kernel/kernel.bin

# gcc -ffreestanding -O0 -c basic.c -o basic.o # Compile basic C function
# objdump -d basic.o # Show original assembly
# ld -o basic.bin -Ttext 0x0 basic.o --oformat binary
# ndisasm -b 32 basic.bin > basic.dis # Disassemble binary into basic assembly
# head -n 100 basic.dis # Show assembly from disassembled binary