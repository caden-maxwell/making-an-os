[org 0x7c00] ; BIOS loads boot sector to 0x7c00, so we need to tell the assembler that

; Save the boot drive to use later
mov [BOOT_DRIVE], dl

; Set up the stack far away
mov bp, 0x8000
mov sp, bp

mov bx, 0x9000 ; Read from hard disk to 0x0000(ES):0x9000(BX)
mov dh, 4 ; Number of sectors to read (just reads dummy sectors for now)
mov dl, [BOOT_DRIVE]
call disk_load

; Print the first loaded word from each of the 4 sectors
mov dx, [0x9000]
call print_hex ; 0x1337
mov dx, [0x9000 + 512]
call print_hex ; 0xdead
mov dx, [0x9000 + 1024]
call print_hex ; 0xdada

cli

lgdt [gdt_descriptor]

mov eax, cr0	; To make the switch to protected mode, we set
or eax, 0x0001	; the first bit of CR0, a CPU control register
mov cr0, eax

jmp CODE_SEG:init_pm

[bits 32]
; Beginning of code in 32-bit protected mode
init_pm:

	mov ebx, MSG
	call print_string_pm

	jmp $

MSG:
	db "Loaded into 32-bit protected mode", 0

%include "boot/print/print_string.asm"
%include "boot/print/print_string_pm.asm"
%include "boot/print/print_nl.asm"
%include "boot/print/print_hex.asm"
%include "boot/disk_load.asm"
%include "boot/gdt.asm"

; Global vars
BOOT_DRIVE db 0

times 510-($-$$) db 0	; Pad boot sector with zeroes to 510 bytes
dw 0xaa55				; Use magic number to signify that this is a boot loader to the BIOS

; Add dummy sectors after the boot sector
times 256 dw 0x1337
times 256 dw 0xdead
times 256 dw 0xdada
