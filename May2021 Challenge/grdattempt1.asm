
*=$C000



	ldy #0
	stx TEMPX
	stx SCREENX
NextLetter:

	lda letter1,y
	sta SHIFTED
//break
	jsr Drawline
	inc SCREENX
	inc SCREENX

	lda letter2,y
	sta SHIFTED
	jsr Drawline

	ldx #0
	stx TEMPX
	clc
    lda screen+1
    adc #40
    sta screen+1
    bcc cont
    inc screen+2
cont:  
    lda #0
    sta SCREENX  
	iny
	cpy #8
	bne NextLetter
	rts

Drawline:
    ldx #0
    stx TEMPX
loop:	
    lda SHIFTED
    asl
    sta SHIFTED
    bcs char1
    lda #$20
    bcc store
char1:    
    lda #160
store:
    ldx SCREENX
screen:    
	sta $0568,x	
	
	inc SCREENX
	inc TEMPX
	ldx TEMPX
	cpx #$8
	bne loop
    rts


TEMPX:
	.byte 00
SCREENX:
	.byte 00
SHIFTED:
	.byte 00

letter1:
	.byte %00111000
	.byte %01111100
	.byte %10110001
	.byte %01111100
	.byte %11111110
	.byte %01111100
	.byte %11000110
	.byte %01111100

letter2:
	.byte %11111111
	.byte %10000001
	.byte %10111001
	.byte %10111001
	.byte %10110001
	.byte %10100001
	.byte %10100001
	.byte %11111111
