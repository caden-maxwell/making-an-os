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

; [bits 32]
; ; Define constants
; VIDEO_MEMORY equ 0xb8000
; WHITE_ON_BLACK equ 0x0f

; ; prints a null - terminated string pointed to by EBX
; print_string_pm:
; 	pusha
; 	mov edx, VIDEO_MEMORY ; Set edx to the start of vid mem.

; 	.forLoop:
; 		mov al, [ebx] ; Store the char at EBX in AL
; 		mov ah, WHITE_ON_BLACK ; Store the attributes in AH

; 		cmp al, 0 ; if (al == 0) , at end of string , so
; 		je .done; jump to done

; 		mov [edx] , ax ; Store char and attributes at current character cell.
; 		inc ebx ; Increment EBX to the next char in string.
; 		add edx, 2 ; Move to next character cell in vid mem.
; 		jmp .forLoop ; loop around to print the next char.

; 	.done:
; 	popa
; 	ret ; Return from the function
