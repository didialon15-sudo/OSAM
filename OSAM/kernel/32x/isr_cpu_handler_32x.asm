[bits 32]
[org 0x00008a00]
vga equ 0x000b8000

isr0:;divide by zero
    pushad
    
    mov edi, vga
    mov ax, 0x4f45
    mov word [edi], ax

    popad

    
    jmp .hang

.hang:
    cli
    hlt
    jmp .hang


times 512-($-$$) db 0
