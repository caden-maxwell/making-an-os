org 0x7c00
start:
	mov si, myString

	mov ah, 0x0e ; Scrolling teletype BIOS routine
	.printStr:
	cmp byte [si], 0 ; Keep going until we find a null byte
	je .endPrintStr

	mov al, byte [si]
	int 0x10

	inc si
	jmp .printStr
	.endPrintStr:

jmp $

myString db 'Hello, World!', 0

times 510-($-$$) db 0 ; Pad boot sector with zeroes to 510 bytes
dw 0xaa55 ; Use magic number to signify that this is a boot loader to the BIOS