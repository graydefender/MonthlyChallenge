	cpu 6502ill
	org $c000
	// y = $ff from the calling code
	ldx #2		// iterate over 3 chars
	iny			// set y to 0
CharacterLoop:
	stx 6		// save x in ZP for next index
	lda 2,x		// get next character
	asl			// multiply by 8 to get font data address
	asl
	asl
	sta 7		// low byte address of Font ROM data for this character
	lda #$d0>>1 // handle high byte of font data address
	rol			// shift in lowest bit of Font ROM address, leaves C clear
	sta 8		// high byte address of Font ROM data for this character

	lda scrnLo,x // set up the screen/color destination
	sta scrnTrgLo // update low byte of screen target
	sta colTrgLo // same low byte used for color target
	adc #41		// offset to shadow destination
	sta scrnShadeTrgLo // update low byte of screen shadow target

	ldx #8		// start at offset 8 so I can use rts opcode for first byte
	 // this scope draws one 7x7 character
RowLoop:
	lsr 1		// make Font ROM data visible
	lda (7),y	// read byte from Font ROM data, Y is always 0
	inc 7		// increment address of Font ROM data
	rol 1		// restore IO & RAM memory
	asl			// leftmost bit is always empty so skip that
	// this scope draws one 7 bit row of font graphics
BitLoop:
	inx			// increment dest offset
	asl			// shift one bit left of font row
	bcc BitLoop // repeat until non-zero
colTrgLo = *+1
	inc $d968,x // set color to white
	tay			// save remaining font graphics bits
	lda #160	// reverse space screen code
scrnTrgLo = *+1
	sta $568,x	// set inverted space
scrnShadeTrgLo = *+1
	sta $591,x	// also on shadow
	tya			// restore remaining font graphics bits
	bne BitLoop // repeat until all bits in byte drawn on screen
	// C = 0, Y = 0, A = 0, X = screen offset
	lda #$f8	// and X with this before subtracting
	sax #~(40-1) // sax = txa / and #$f8 / sbc #~(40-1) == adc #40-1 / tax
	bcc RowLoop // on the 8th row the carry will overflow
	ldx 6		// restore character index
	dex			// next one
	bpl CharacterLoop // repeat until character index < 0
scrnLo:
	rts			// first character screen offset
	.byte $60+10, $60+20 // 2nd and 3rd character screen offset