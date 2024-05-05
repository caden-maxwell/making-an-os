[org 0x7c00] ; BIOS loads boot sector to 0x7c00, so we need to tell the assembler that

mov di, 0x1337
call print_hex

jmp $

%include "print_string.asm"

print_hex:
	push bx
	mov bx, 3
	.forLoop:
		cmp bx, 0
		jl .endForLoop
		
		mov cx, di
		and cl, 0x0f
		or cl, 0x30
		cmp cl, 0x39 ; if cl is less than or equal to 0x39 (9)
		jle .skipShift ; then don't skip to the alpha characters
		add cl, 7
		.skipShift:
		shr di, 4 ; Shift 4 bits so we can repeat on the lowest 4 bits again

		mov [bx+HEX_OUT+2], cl

		dec bx
		jmp .forLoop
	.endForLoop:

	mov di, HEX_OUT
	call print_string
	call print_nl

	pop bx
    ret

HELLO:
	db 'Hello, World!', 0

HEX_OUT:
	db '0x0000', 0

times 510-($-$$) db 0	; Pad boot sector with zeroes to 510 bytes
dw 0xaa55				; Use magic number to signify that this is a boot loader to the BIOS
