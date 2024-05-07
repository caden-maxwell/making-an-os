; Prints DX as hex with a newline
print_hex:
	push bx
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

	pop bx
    ret
	
HEX_OUT db '0x0000', 0