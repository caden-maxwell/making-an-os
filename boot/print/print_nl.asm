[bits 16]

; Prints a newline and carriage return
print_nl:
    ; Print the newline character 0xa
    mov ax, 0xe0a
    int 0x10

	; Print the carriage return character 0xd
    mov al, 0xd
    int 0x10

    ret
