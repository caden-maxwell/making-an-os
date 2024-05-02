org 0x7c00

start:
	mov cx, 0
	mov ah, 0x0e
	mov al, 'A'

	.loop:
	cmp cx, 26
	je .endLoop

	int 0x10
	inc al

	inc cx
	jmp .loop
	.endLoop:

jmp $

times 510-($-$$) db 0
dw 0xaa55