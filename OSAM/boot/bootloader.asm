[bits 16]
[org 0x7c00]

GDT_OFFSET equ 0x7e00 ; Physical RAM address of Sector 2

_start:
    xor ax, ax ; Reset segments to zero
    mov ds, ax
    mov es, ax

    mov [BOOT_DRIVER], dl   ; Save BIOS boot drive index

    ;--- Set up stack space ---
    cli
    mov ss, ax
    mov sp, 0x7c00
    mov bp, sp
    sti

    ;--- Load Sector 2 into RAM at 0x7E00 ---
    mov bx, GDT_OFFSET ; Target buffer offset
    mov al, 1 ; Read 1 sector
    mov ch, 0 ; Cylinder 0
    mov dh, 0 ; Head 0
    mov cl, 2 ; Sector 2
    mov dl, [BOOT_DRIVER] ; Drive ID
    mov ah, 0x02 ; BIOS read sector function
    int 0x13

    jc halt ; Crash on disk error
    cmp al, 1
    jne disk_error
    
    ; Jump directly to the newly loaded code in RAM
    jmp stage2
    
halt:
    cli
    hlt
    jmp halt

disk_error:
    mov ah, 0x0E
    mov al, 'E'
    int 0x10
    jmp halt

BOOT_DRIVER db 0

; Pad exactly to the end of Sector 1
times 510-($-$$) db 0 ;start of sector 1 is from addr: 0x7c00 until 0x7dff
dw 0xAA55

; =========================================================================
; SECTOR 2 STARTS HERE (Physical location: 0x7E00)
; =========================================================================
gdt_start:
    ; Null Descriptor (Required 8 bytes)
    dd 0x0, 0x0 
    
    ; Code Segment Descriptor (Offset 0x08/ 0b0000 1000)
    dw 0xffff ; Limit (0-15)
    dw 0x0000 ; Base (0-15)
    db 0x00 ; Base (16-23)
    db 0x9a ; Access Byte
    db 0xcf ; Flags + Limit (16-19)
    db 0x00 ; Base (24-31)
    
    ; Data Segment Descriptor (Offset 0x10)
    dw 0xffff ; Limit (0-15)
    dw 0x0000 ; Base (0-15)
    db 0x00 ; Base (16-23)
    db 0x92 ; Access Byte
    db 0xcf ; Flags + Limit (16-19)
    db 0x00 ; Base (24-31)
gdt_end:

gdt_desc:
    dw gdt_end - gdt_start - 1
    dd 0x7c00 + (gdt_start - $$)

stage2:
    cli
    lgdt [gdt_desc] ; Load the Global Descriptor Table
    
    mov eax, cr0
    or eax, 1 ; Flip bit 0 to enable Protected Mode
    mov cr0, eax

    ; Far jump clears 16-bit real mode registers and enforces 32-bit execution
    jmp 0x08:init_32bit


[bits 32]

KERNEL_SETUP_32_OFFSET equ 0x00008c00 ; Physical RAM address of THE KERNEL 32 BITS

init_32bit:
    ; Establish execution environment using Data Selector (0x10)
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax 
    mov fs, ax 
    mov gs, ax
    mov esp, 0x90000 ; Set up a safe 32-bit protected mode stack

    jmp KERNEL_SETUP_32_OFFSET
hang_32bit:
    hlt
    jmp hang_32bit


; Pad Sector 2 precisely out to 512 bytes 
times 512-($-stage2) db 0 ;start of sector 2 is from addr: 0x7e00 until 0x7fff