[org 0x8600]
[bits 32]

=======================================

;from addr 0x8600 until 0x93ff it for drivers
;after addr 0x93ff you enter to the idt section

dont keep write this code until you will see 
massege that wrote on it from addr 0x400 until
the last addr that will be
=======================================

;for write to port 0x64 we will need to wait until that the port 
;will not be busy when we write to them


KD_wait_output_full: ;*kernel function: before read the answer from 0x60, we want to be sure that will have data in obf
;and it of the Keyboard Driver 

    push ax ;we want to be sure that this function doesnt replace "important" value to other value in ax for that we push the
    ;"important" value into stack and after that we protact the "important" value 
    
    jmp .OUT_check_loop ;jump to the .OUT_check_loop

.OUT_check_loop:;this function is check if obf = 1 and the data is on keyboard driver

    in al,0x64 ;al = status register of the keyboard

    test al,0x01 ; check "if obf(output buffer full) is 1"(the obf with data of some driver)
    jz .OUT_check_loop ; if obf = 0(zf=1) he keep wait until obf = 1 (zf = 0)

    test al,0x20;zf = 1: 0x20=0 --> "the data in port 0x60 with data of the keyboard driver" --> we will read the data of port 0x60
    jnz .OUT_check_loop ;zf = 0: 0x20=1 --> "the data in port 0x60 with data of the mouse driver"
    mov ,1 ;obf, data is of keyboard in 0x60 = 1

    pop al
    ret

KD_wait_input_full:

times 512 - ($ - $$) db 0