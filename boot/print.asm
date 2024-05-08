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

; Prints DX as hex with a newline
print_hex:
	pusha
	mov bx, 3
	.forLoop:
		cmp bx, 0
		jl .endForLoop
		
		mov cx, dx
		and cl, 0x0f
		or cl, 0x30
		cmp cl, 0x39 ; if cl is less than or equal to 0x39 (9)
		jle .skipShift ; then don't skip to the alpha characters
		add cl, 7
		.skipShift:
		shr dx, 4 ; Shift 4 bits so we can repeat on the lowest 4 bits again

		mov [bx+HEX_OUT+2], cl

		dec bx
		jmp .forLoop
	.endForLoop:

	mov bx, HEX_OUT
	call print_string
	call print_nl

	popa
    ret

HEX_OUT db '0x0000', 0
	
; Prints a newline and carriage return
print_nl:
    ; Print the newline character 0xa
    mov ax, 0xe0a
    int 0x10

	; Print the carriage return character 0xd
    mov al, 0xd
    int 0x10

    ret
