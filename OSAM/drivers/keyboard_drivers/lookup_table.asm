;the addresses: 0x8000 until 0x83ff it for the "_VGA_lib.asm".-
[org 0x8400]
;sector 5: lookup table, start from 0x8400 until 0x85ff.
;from start until the end we have 512 byte.

scancode_table:
    ;line 6:
    db 0x1b ;escape (lookup_tablesESC)
    ;line 5:
    db '1'
    db '2'
    db '3'
    db '4'
    db '5'
    db '6'
    db '7'
    db '8'
    db '9'
    db '0'
    db '-'
    db '='
    db 0x08 ;backspace
    ;line 4:
    db 0x09 ;tab
    db 'Q'
    db 'W'
    db 'E'
    db 'R'
    db 'T'
    db 'Y'
    db 'U'
    db 'I'
    db 'O'
    db 'P'
    db '['
    db ']'
    db 0x0d ;enter
    ;line 3:
    db 0x1d;LEFT CTRL
    db 'A'
    db 'S'
    db 'D'
    db 'F'
    db 'G'
    db 'H'
    db 'J'
    db 'K'
    db 'L'
    db ';'
    db 0X27 ;this character: '
    db '`'
    ;line 2:
    db 0x00; left shift:null
    db '\'
    db 'Z'
    db 'X'
    db 'C'
    db 'V'
    db 'B'
    db 'N'
    db 'M'
    db ','
    db '.'
    db '/'
    db 0x00;right shift:null
    db 0x00;prtsc
    db 0x00;alt
    db 0x20;space
    db 0x00;caps
    ;f1 - f10 = 0x00 (null)
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00

    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00 
    db 0x00 

times 512 - ($ - $$) db 0