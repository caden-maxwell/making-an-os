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

; load kernel
load_kernel:
	mov bx, MSG_KERNEL
	call print_string
	call print_nl

	mov bx, KERNEL_OFFSET ; Read from hard disk to 0x0000(ES):KERNEL_OFFSET(BX)
	mov dh, 15 ; Number of sectors to read (just reads dummy sectors for now)
	mov dl, [BOOT_DRIVE]
	call disk_load

	; Sanity check for correctly loading kernel
	mov dx, [KERNEL_OFFSET]
	call print_hex

	ret

[bits 32]

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
MSG_RM: db "Started in 16-bit real mode.", 0
MSG_PM: db "Successfully loaded into 32-bit protected mode.", 0
MSG_KERNEL: db "Loading Kernel from disk to memory...", 0

times 510-($-$$) db 0	; Pad boot sector with zeroes to 510 bytes
dw 0xaa55				; Use magic number to signify that this is a boot loader to the BIOS
