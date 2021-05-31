
*=$C000 "Gray Defender Code"

.const ScreenRam      = $400
.const TEMPX          = $14
.const SCREENX        = $09
.const SHIFTED        = $15
.const letters        = $20


                    lda #$5e     // Reset ZP variables
                    sta $f5
                    sta $fd

                    lda #$d9
                    sta $fe
                    sta $fa
                 
                    lda #$87
                    sta $f7
                    sta $f9
                 
                    lda #$05
                    sta $f6
                    sta $f8                    


                    lda #$33        //; make the CPU see the Character Generator ROM...
                    sta $01         //; ...at $D000 by storing %00110011 into location $01

                    ldx #0
                    ldy #2
Lc:                 sty Char

Load_Chars:               
                    lda Char: $2                   
                    ldy #$d0
                    sty $fc         

                    asl
                    asl
                    asl
                    bcc !+
                    inc $fc
!:                  sta $fb
                    ldy #7      
!:                   
                    lda ($fb),y
                    sta letters,x
                    inx
                    dey
                    bpl !-
                    ldy Char
                    iny                    
                    cpy #5
                    bne Lc

                    lda #$37        //; switch in I/O mapped registers again...
                    sta $01         //; ... with %00110111 so CPU can see them

                    ldy #7
                   
NextLetter:
                    lda letters,y
                    
                    jsr Drawline     // Display first set of 8 characters on line for first Letter         
                    lda letters+8,y
                    jsr Drawline     // Display second set of 8 characters on line for sec Letter                 
                    lda letters+16,y                    
                    jsr Drawline     // Display third set of 8 characters on line for third Letter                 

                    ldx #$0          // x axis screen offset
                    stx SCREENX  

                    clc              // Move to next row 
                    lda $f5
                    adc #40
                    sta $f5
                    sta $fd
                    bcc !+
                    inc $f6
                    inc $fe
!:
                    clc
                    lda $f7
                    adc #40
                    sta $f7
                    sta $f9
                    bcc !+
                    inc $f8
                    inc $fa
!:
                    dey
                    bpl NextLetter
                    rts
Drawline:                       
                    sta SHIFTED
                    clc
                    lda SCREENX
                    adc #10                     
                    sta SCREENX

                    sty TEMPX
                    ldx #7                    
                    ldy SCREENX
loop:   
                    asl SHIFTED                    
                    bcc !+                                       
//**************************************
PokeScreen: 
                    lda #160
                    sta ($f5),y  // White CHAR
                    sta ($f7),y  // Black CHAR (SHADOW)
                    lda #1
                    sta ($fd),y  // WHITE CHAR
                    lda #0
                    sta ($f9),y  // BLACK CHAR (SHADOW)
//**************************************                                        
!:
                    iny                  
                    dex
                    bne loop 
                    ldy TEMPX   
                    rts
