org 0x7c00

start:
	mov ah, 0x0e
	mov al, 'A'

	.loop:
	cmp al, 'Z' + 1
	je .endLoop

	int 0x10
	inc al

	jmp .loop
	.endLoop:

jmp $

times 510-($-$$) db 0
dw 0xaa55