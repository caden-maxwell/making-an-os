#!/bin/bash

# Assembles the boot file
nasm -f bin boot/boot.asm -o boot/boot.bin

# Compile and assemble kernel
gcc -ffreestanding  -c kernel/kernel.c -o kernel/kernel.o
objcopy -O binary -j .text kernel/kernel.o kernel/kernel.bin
# ld -o kernel/kernel.bin -Ttext 0x1000 kernel/kernel.o --oformat binary

# Concatenate boot sector and kernel
cat boot/boot.bin kernel/kernel.bin > os-image.bin

# Starts the emulator
# qemu-system-x86_64 -drive format=raw,file=os-image.bin
qemu-system-x86_64 -drive file=os-image.bin,if=floppy,index=0,media=disk,format=raw
