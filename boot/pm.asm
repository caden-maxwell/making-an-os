[bits 16]

switch_to_pm:
cli ; Clear all interrupts

lgdt [gdt_descriptor] ; Load the Global Descriptor Table defined in /boot/gdt.asm

mov eax, cr0	; To make the switch to protected mode, we set
or eax, 0x0001	; the first bit of CR0, a CPU control register
mov cr0, eax

jmp CODE_SEG:init_pm

[bits 32]

; Beginning of code in 32-bit protected mode
init_pm:

	mov ebx, LOADED_PM
	call print_string_pm

	jmp $

LOADED_PM:
	db "Loaded into 32-bit protected mode", 0
