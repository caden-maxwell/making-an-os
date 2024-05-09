[bits 32]
[extern main] ; We expect the main function to be defined in another file

global _start ; We need a _start symbol for the linker to be happy

_start:
    ; Need to explicitly call main in case we
    ; have functions defined before it. These functions
    ; will cause an unexpected early return back to 
    ; the bootloader if main isn't called first.
    call main

    jmp $
