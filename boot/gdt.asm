[bits 16]

; For the following GDT code, see https://wiki.osdev.org/GDT_Tutorial
; also see: /notes/gdt.md
gdt_start:

; null segment
; Defines 8 zero-bytes
; 00 00 00 00
; 00 00 00 00
gdt_null:
	dq 0x0

; code segment
; 00 cf 9a 00
; 00 00 ff ff
gdt_code:
	dd 0x0000ffff
	dd 0x00cf9a00

; data segment
; 00 cf 92 00
; 00 00 ff ff
gdt_data:
	dd 0x0000ffff
	dd 0x00cf9200

gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start - 1	; GDT size
	dd gdt_start				; GDT address

; Consts
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
