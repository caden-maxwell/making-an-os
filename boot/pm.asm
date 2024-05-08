[bits 16]

; Switch into 32-bit protected mode
switch_to_pm:
cli ; Clear all interrupts

lgdt [gdt_descriptor] ; Load the Global Descriptor Table defined in /boot/gdt.asm

mov eax, cr0	; To make the switch to protected mode, we set
or eax, 0x0001	; the first bit of CR0, a CPU control register
mov cr0, eax

; Make a far jump to the 32-bit code.
; This forces the CPU to flush its cache of
; pre-fetched and real-mode decoded instructions,
; which can cause problems.
jmp CODE_SEG:init_pm

[bits 32]

; Initilize stack and registers in protected mode
init_pm:
	; Point old segment registers to the data segment from
	; gdt.asm since the old ones are meaningless in protected mode
	mov ax, DATA_SEG
	mov ds, ax 
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	; Update our stack position to be at the top of free space
	mov ebp, 0x90000
	mov esp, ebp 
	call begin_pm
