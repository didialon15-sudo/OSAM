[org ]
[bits 32]

;text mode:
;addresses & registers: ===================================================================\
 ;                                                                                       \ /
 ; - address: 0x000b8000\____________________________________________________________     |
  ;||- VGA address,                                                                 ||    |
  ;||- start from 0x000b8000 until 0x000B8Fa2(the last letter address is 0x000b8fa0)||    |
  ;\\==============================================================================//     |
 ; - register: edi\_____________________________________________________________________  | 
  ;||- edi info:\___________________________________________________________________   \\ |  
  ;|| |[edi] index 0:\___________________________________________________________  \\  || |  
  ;|| | | the size of [edi] is byte(8 bit, low and high nibble{nibble:...       \\ ||  || |
  ;|| | | his size is 4 bit or half of 8 bits }) this byte get the value of the || ||  || |
  ;|| | | character this value we give to this byte from the ascii table. //----// ||  || |
  ;|| | \----------------------------------------------------------------//        ||  || |
  ;|| |                                                                            ||  || |
  ;|| |[edi+1] index 1:\______________________________________________    //-------//  || |
  ;|| | |                                                            \\   ||           || |
  ;|| | | *"HEX: 0XHL":\___________________________________________  ||   ||  //-------// |
  ;|| | |  | "(H)": that mean we are now talk about the High nibble| ||   ||  ||          |
  ;|| | |  | "(L)": that mean we are now talk about the Low nibble | ||   ||  ||   /------/
  ;|| | |  |_______________________________________________________| ||   ||  ||   |
  ;|| | | the size of [edi+1] is byte (the same size of index 0)     ||   ||  ||   |
  ;|| | | this index have 2 things that he does:\______________      ||   ||  ||   |
  ;|| | | |1. low nibble(hex: 0xH(L)):\________________       \\     ||   ||  ||   |
  ;|| | | | | setup the color of the character,       \\      ||     ||   ||  ||   | 
  ;|| | | | | we setup the color value often with hex ||      ||     ||   ||  ||   |
  ;|| | | | \-----------------------------------------//      ||     ||   ||  ||   |
  ;|| | | |                                                   ||     ||   ||  ||   |
  ;|| | | |2. high nibble(hex: 0x(H)L):\___________________   ||     ||   ||  ||   |
  ;|| | | | | setup the color of the character background \\  ||     ||   ||  ||   |
  ;|| | | | \---------------------------------------------//  ||     ||   ||  ||   |
  ;|| | | \---------------------------------------------------//     ||   ||  ||   |
  ;|| | \------------------------------------------------------------//   ||  ||   |
  ;|| \-------------------------------------------------------------------//  ||   |
  ;\\_________________________________________________________________________//  / \
;===================================================================================/



;80 תווים בשורה על 25 שורות

VGA_clear_all: ;clear screen *kernel function
    push edi
    cmp edi, 0x000b8000
    jne .set_addr
    je .clear_loop
.set_addr: ;setup edi to the addr of vga 
    mov edi,0x000b8000 ; phisicall address of vga
    jmp .clear_loop
.clear_loop:
    mov byte [edi],0x00 ; character NULL
    mov byte [edi+1],0xf0 ; white BG, color letter is black

    add edi,2

    cmp edi,0x000B8Fa0 ; the last letter address
    jne .clear_loop
    je .eloop
.eloop: ;endloop
    pop edi
    ret


VGA_set_letter:; *kernel function
    push edi
    push esi
    mov edi,0x000b8000
    imul esi,80;esi=y*80
    add esi,edx; esi + x
    imul esi,2
    add edi,esi
    mov byte [edi],al;letter
    mov byte [edi+1],ah;color char,BG
    pop esi
    pop edi
    ret



times 1024-($-$$) db 0;start from sector 3(from 0x8000 until 0x81ff, 512 bytes) and end in sector 4(from 0x8200 until 0x83ff, 512 bytes), start addr: 0x8000, end addr:0x83ff