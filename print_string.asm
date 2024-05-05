; Put the first address of the message into the di register
print_string:
	mov	ah,	0x0e ; Scrolling teletype BIOS routine
	.forLoop:
		cmp	byte [di], 0 ; Keep going until we find a null byte
		je .endForLoop

		mov al, byte [di]
		int 0x10

		inc di
		jmp .forLoop
	.endForLoop:
    ret

print_nl:
    mov ax, 0x0e0a
    int 0x10
    mov ax, 0x0e0d
    int 0x10
    ret
