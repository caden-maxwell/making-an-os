[org 0x7c00] ; BIOS loads boot sector to 0x7c00, so we need to tell the assembler that

; Save the boot drive to use later
mov [BOOT_DRIVE], dl

; Set up the stack far away
mov bp, 0x8000
mov sp, bp

mov bx, 0x9000 ; Read from hard disk to 0x0000(ES):0x9000(BX)
mov dh, 3 ; Number of sectors to read (just reads dummy sectors for now)
mov dl, [BOOT_DRIVE]
call disk_load

; Print the first loaded word from each of the 4 sectors
mov dx, [0x9000]
call print_hex ; 0x1337
mov dx, [0x9000 + 512]
call print_hex ; 0xdead
mov dx, [0x9000 + 1024]
call print_hex ; 0xdada
jmp switch_to_pm

[bits 32]

begin_pm:
	mov ebx, LOADED_PM
	call print_string_pm

	ret

%include "boot/print.asm"
%include "boot/print_pm.asm"
%include "boot/disk_load.asm"
%include "boot/gdt.asm"
%include "boot/pm.asm"

; Global vars
BOOT_DRIVE: db 0
LOADED_PM: db "Finished loading into 32-bit protected mode", 0

times 510-($-$$) db 0	; Pad boot sector with zeroes to 510 bytes
dw 0xaa55				; Use magic number to signify that this is a boot loader to the BIOS

; Add dummy sectors after the boot sector
times 256 dw 0x1337
times 256 dw 0xdead
times 256 dw 0xdada
