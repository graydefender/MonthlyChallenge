.cpu _6502
.pc = $c000 "Wherever I May Zoom"

				.const CHARACTER_ROM_ADDRESS	= $d000
				.const CHAR_BYTE				= $60			//Temporary variable for the actual character's current bitmap byte (fun fact: this is also the opcode of RTS, see below)
				.const INVERSE_SPACE 			= $a0
				.const ROW_SIZE 				= $28
				.const SHADOW_DELTA 			= ROW_SIZE + 1
				.const CHAR_ADDRESS				= $74			//Pointer to Character ROM. By default $75 contains $d0, so we don't have to initalize the address's high byte
				.const TEMP_YR					= $fd
														
NextChar:		iny												//YR = 255 by default - we start from 0
				lax $02,y										//Get the next character's screen code. It could be lda $02,y, but there is no ZP Y indexed addressing mode for LDA, but LAX has one ¯\_(ツ)_/¯
				bmi Exit										//Characters are in $02, $03 and $04 and their screen codes are less then 64, so they are non-negative. At $05 there is a constant $91, which is negative. So when we reach $05 we jump to exit. No need to test YR for the value 3
				lsr CHAR_ADDRESS + 1							//The high byte of the Character Address is $d0 (or $d1) at the moment. We divide it by two here, to safely clear the last bit
				asl												//Character ROM address = $d000 + screencode * 8. The screen code cannot be greater then 63, so the forst two bit is always zero
				asl												//After 3 times shits left, AC contains the low byte of the addrees
				asl												//And Carry has the rightmost bit of the high byte.
				sta CHAR_ADDRESS								//Store the low byte of the charcter address
				rol CHAR_ADDRESS + 1							//High byte = High byte * 2 + Carry = ($d0 or $d1)

				lda CharPositions,y								//Get the topleft foreground screen address's low byte from the table
				sta ForegroundScreen							//Store it for the foreground screen
				sta ForegroundColor								//And store it for the foreground color too (both of them have the same low byte)
				adc #SHADOW_DELTA								//Increment it by 41 for shadow screen address
				sta ShadowScreen								//And store it
				sty TEMP_YR										//Save YR
				lax #$00										//AC, XR, YR = 0. lax #im is an indeterministic opcode, but it is ok to use with the argument 0
				tay
				

NextByte:		lsr $01											//Map CHAREN to read from
				lda (CHAR_ADDRESS),y 							//Get a byte from Character ROM
				sta Exit: CHAR_BYTE								//And store it. The address is $60 - we embed / hide here an extra RTS opcode in the argument.
				rol $01											//Map I/O back to write to
				
				lda #INVERSE_SPACE								//AC = 160 (inverse space)
				asl CHAR_BYTE									//Put the next bit to the 7th position (the leftmost bit is always 0 at the beginning, so we start from bit 6 - which is actually now bit 7)
NextBit:		bpl SkipDrawing									//If bit 7 is not set, skip the drawing part
				sta ForegroundScreen: $0501,x					//Else draw an inverse space for forecolor
				sta ShadowScreen: $0502,x						//And draw another inverse space for shadow
				inc ForegroundColor: $d903,x					//And set foreground to white. The color ram is filled with zeros (black), so we don't need to set color for the shadow
SkipDrawing:	inx												//Set XR for next bit on screen
				asl CHAR_BYTE									//Shift the next bit to bit 7 (...and to Flag N)
				bne NextBit										//If there are any bits to draw, jump back
				
NextRow:		iny 											//YR points to the next byte from Character ROM
				lda #%11111000									//Mask to clear the last 3 bits of XR
				axs #-ROW_SIZE									//AXS #V is for XR = XR & AC - V. So we can clear XR's last three bit, and add 40 to it with two statements, instead of txa, and #%11111000, adc #40, tax. Carry will always be set here because of asl CHAR_BYTE
				bcc NextByte									//XR now pointst to the next line's first column. Luckily, if we reach the eighth row XR is overflow (7*40 = 280), and Carry wil be set. Otherwise we jump back to draw a new line.
				ldy TEMP_YR										//Load YR back
				bcs NextChar									//Go to draw the next character

CharPositions: 	.byte $69, $73, $7d								//Low bytes of foreground's screen addresses
