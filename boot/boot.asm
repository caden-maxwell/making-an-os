[org 0x7c00] ; BIOS loads boot sector to 0x7c00, so we need to tell the assembler that
KERNEL_OFFSET equ 0x1000

; Save the boot drive to use later
mov [BOOT_DRIVE], dl

; Set up the stack far away
mov bp, 0x9000
mov sp, bp

mov bx, MSG_RM
call print_string
call print_nl

call load_kernel

jmp switch_to_pm

jmp $

[bits 16]
; load kernel from disk
load_kernel:
	mov bx, MSG_KERNEL_LOAD
	call print_string
	call print_nl

	mov bx, KERNEL_OFFSET ; Read from disk to 0x0000(ES):KERNEL_OFFSET(BX)
	mov dh, 15 ; Number of sectors to read
	mov dl, [BOOT_DRIVE]
	call disk_load

	mov bx, MSG_KERNEL_SUCC
	call print_string
	call print_nl

	ret

[bits 32]
;  First code to run in 32-bit protected mode. Calls kernel's entry point
begin_pm:
	mov ebx, MSG_PM
	call print_string_pm

	call KERNEL_OFFSET

	jmp $

%include "boot/print.asm"
%include "boot/print_pm.asm"
%include "boot/disk_load.asm"
%include "boot/gdt.asm"
%include "boot/pm.asm"

; Global vars
BOOT_DRIVE: db 0
MSG_RM: db "Started boot sector in 16-bit real mode.", 0
MSG_PM: db "Successfully booted into 32-bit protected mode.", 0
MSG_KERNEL_LOAD: db "Loading kernel from disk...", 0
MSG_KERNEL_SUCC: db "Successfully loaded kernel from disk.", 0

times 510-($-$$) db 0	; Pad boot sector with zeroes to 510 bytes
dw 0xaa55				; Use magic number to signify that this is a boot loader to the BIOS
