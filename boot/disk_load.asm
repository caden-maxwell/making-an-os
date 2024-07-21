[bits 16]

; load DH sectors to ES:BX from drive DL
disk_load:
    push dx ; Store DX on stack so later we can recall
            ; how many sectors were requested to be read

    mov ah, 0x02 ; BIOS read sector function
    mov al, dh ; Read (DH) sectors
    mov ch, 0x00 ; Select cylinder 0
    mov dh, 0x00 ; Select head 0
    mov cl, 0x02 ; Start reading from sector 2

    int 0x13
    jc disk_error ; Jump if error (carry flag is set on error)

    pop dx
    cmp dh, al ; if AL (# sectors read) != DH (# sectors expected), error out
    jne disk_error

    ret

disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string

    mov ah, 0x01
    int 0x13

    mov dl, ah
    mov dh, 0x00
    call print_hex

    jmp $

DISK_ERROR_MSG db "Disk read error: ", 0
