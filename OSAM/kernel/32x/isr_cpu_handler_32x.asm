[bits 32]
[org 0x00008a00]
vga equ 0x000b8000

isr0:;divide by zero
    pushad
    
    mov edi, vga
    mov ax, 0x4f45
    mov word [edi], ax

    popad

    
    jmp shutdown
shutdown:
    mov dx, 0x604   ; כתובת ה-Port של ACPI ב-QEMU
    mov ax, 0x2000  ; פקודת הכיבוי (Shut down)
    out dx, ax      ; שליחת הפקודה לחומרה הווירטואלית
.hang:
    cli
    hlt
    jmp .hang


times 512-($-$$) db 0