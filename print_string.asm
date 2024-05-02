print_string:
    push ax

	mov	ah,	0x0e ; Scrolling teletype BIOS routine
	printStr:
		cmp	byte [di], 0 ; Keep going until we find a null byte
		je endPrintStr

		mov al, byte [di]
		int 0x10

		inc di
		jmp printStr
	endPrintStr:

    pop ax
    ret

print_nl:
    push ax

    mov ax, 0x0e0a
    int 0x10
    mov ax, 0x0e0d
    int 0x10

    pop ax
    ret
