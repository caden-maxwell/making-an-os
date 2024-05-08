[bits 16]

; Prints a null-terminated string pointed to by BX
print_string:
	pusha

	mov	ah,	0xe ; Scrolling teletype BIOS routine
	.forLoop:
		cmp	byte [bx], 0 ; Keep going until we find a null byte
		je .endForLoop

		mov al, byte [bx]
		int 0x10

		inc bx
		jmp .forLoop
	.endForLoop:

	popa
    ret
