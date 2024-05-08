#!/bin/bash

gcc -ffreestanding -O0 -c basic.c -o basic.o # Compile basic C function
# objdump -d basic.o # Show original assembly
ld -o basic.bin -Ttext 0x0 basic.o --oformat binary
ndisasm -b 32 basic.bin > basic.dis # Disassemble binary into basic assembly
head -n 100 basic.dis # Show assembly from disassembled binary
