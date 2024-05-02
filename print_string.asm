print_string:
    push ax

    mov ah, 0x0e ; Scrolling teletype BIOS routine
    .printStr:
    cmp byte [si], 0 ; Keep going until we find a null byte
    je .endPrintStr

    mov al, byte [si]
    int 0x10

    inc si
    jmp .printStr
    .endPrintStr:

    pop ax
    ret
