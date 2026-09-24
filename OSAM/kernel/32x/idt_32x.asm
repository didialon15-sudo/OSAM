[org 0x00008000];sector 3

idt_32x_start:;x
    ;entry 0: IDTR Offset + 0
    dw 0x8a00
    dw 0x08
    dw 0x8E00
    dw 0x0000
    ;entry 1: IDTR Offset + 8

idt_32x_end:;x+2047

times 2048 - ($-$$) db 0 ; from sector 3 until 0x89ff


