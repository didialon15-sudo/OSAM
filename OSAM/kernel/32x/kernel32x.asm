[bits 32] 
[org 0x00009000];start addr: 0x00009000

idt_discriptor: ;starts: 0x00009000
    ;bytes 0 - 1 one less than the size of the idt
    dw 2047; size of idt is 2048 - 1 = 2047

    ;bytes 2 - 5 is pointer to the start address of idt
    ;*>>idt start addr: 0x8000

    dd 0x00008000 ; idt start addr
;ends: 0x00009006 

loading_idtr:;starts: 0x00009007 - 0x0000900e, 8 bytes
    lidt [idt_discriptor]
    sti
    ret

isr_cpu_handler_32 equ 0x00008a00;starts:0x0000900f - 0x00009012, 4 bytes

kernel_32_loop: ;starts:0x00009013
    int 0
times 1024-($-$$) db 0;end addr:0x000093ff