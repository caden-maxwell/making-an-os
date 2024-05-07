; Prints a string starting at BX
print_string:
	push bx
	mov	ah,	0x0e ; Scrolling teletype BIOS routine
	.forLoop:
		cmp	byte [bx], 0 ; Keep going until we find a null byte
		je .endForLoop

		mov al, byte [bx]
		int 0x10

		inc bx
		jmp .forLoop
	.endForLoop:
	pop bx
    ret

print_nl:
    mov ax, 0x0e0a
    int 0x10
    mov ax, 0x0e0d
    int 0x10
    ret
