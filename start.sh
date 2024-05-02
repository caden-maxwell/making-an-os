#!/bin/bash

# Assembles the boot file
nasm -f bin boot.asm -o boot.bin

# Starts the emulator
qemu-system-x86_64 -drive format=raw,file=boot.bin