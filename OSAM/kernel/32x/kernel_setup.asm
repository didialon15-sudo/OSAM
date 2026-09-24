[bits 32]
[org 0x00008c00]

kernel_32 equ 0x00009000
remap_pic equ 0x00008e00

start_up_sys:

    ;this code take care about all things that need to set before jump to the kernel
    ;you only need to call the start addr of each file that set up something 
    ;call remap_pic

    jmp kernel_32



times 512 -($-$$) db 0
    