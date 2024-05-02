[org 0x7c00] ; BIOS loads boot sector to 0x7c00, so we need to tell the assembler that

mov di, hello_msg
call print_string

call print_nl

mov di, goodbye_msg
call print_string

jmp $

%include "print_string.asm"

hello_msg:
	db 'Hello, World!', 0

goodbye_msg:
	db 'Goodbye!', 0

times 510-($-$$) db 0	; Pad boot sector with zeroes to 510 bytes
dw 0xaa55				; Use magic number to signify that this is a boot loader to the BIOS
