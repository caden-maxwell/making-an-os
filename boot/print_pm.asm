[bits 32]

; prints a null-terminated string pointed to by EBX
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY ; Set EDX to the start of video memory

	.forLoop:
		mov al, [ebx] ; Store the char at EBX in AL
		mov ah, WHITE_ON_BLACK ; Store the attributes in AH

		cmp al, 0 ; if we hit a null character, we are done
		je .done

		mov [edx], ax ; Store char and attributes at current character cell
		inc ebx ; Increment EBX to the next char in string
		add edx, 2 ; Move to next character cell in video memory
		jmp .forLoop
	.done:

	popa
	ret

; Define constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f