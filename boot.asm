[org 0x7c00] ; BIOS loads boot sector to 0x7c00, so we need to tell the assembler that

; Save the boot drive to use later
mov [BOOT_DRIVE], dl

; Set up the stack far away
mov bp, 0x8000
mov sp, bp

mov bx, 0x9000 ; Read from hard disk to 0x0000(ES):0x9000(BX)
mov dh, 2 ; Number of sectors to read (just reads dummy sectors for now)
mov dl, [BOOT_DRIVE]
call disk_load

; Print out the first loaded word: 0x1337
mov dx, [0x9000]
call print_hex		

; Print the first word from the 2nd loaded sector: 0xDEAD
mov dx, [0x9000 + 512]
call print_hex

jmp $

%include "print_string.asm"
%include "print_hex.asm"
%include "disk_load.asm"

; Global vars
BOOT_DRIVE db 0

times 510-($-$$) db 0	; Pad boot sector with zeroes to 510 bytes
dw 0xaa55				; Use magic number to signify that this is a boot loader to the BIOS

; Add dummy sectors after the boot sector
times 256 dw 0x1337
times 256 dw 0xdead
