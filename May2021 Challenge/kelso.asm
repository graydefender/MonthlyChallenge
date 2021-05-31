//PK6 == 80 * 3727 = 298,160
//Kelso_____
//May 27th
//Version #12

* = $c000

		//screen setup information
		//shadow msb is hard coded in code below at SHADOW + 1 label ($05)
		//screen msb is already in $d2 - no need to set it up ($05)
		//colour msb is already in $f4 - no need to set it up ($d9)
		//all lsb locations are pulled from a table as needed 

	ldx #$02	//setup the x register to count down the number of characters we are drawing (3 characters [2,1,0])
	LOAD_NEXT_CHAR:
		//char stored in ZP to load in.	
		lda $02, x 	//load in a character from zeropage ... x=0=zp$02, x=1=zp$03 x=2=zp$04
		stx $40		//store x value as we need the x register later for other things.
		asl 		//times accumulator by 2
		asl 		//times accumulator by 4
		asl 		//times accumulator by 8 to get the offset into char rom memory ... this will be the lsb into char rom/memory
		
		//setup char rom/memory location 
		sta CHAR_BYTE_ADDRESS + 0 	//store the char rom lsb
					//calculate and store the msb
		lda #$d0 	//load in $d0.  This is the starting msb value of char rom.
		adc #$00 	//if the x8 above wrapped around, there will be a 1 in the carry.  Add it to $d0
					//no CLC because the ASLs above first clear the carry, then they might set it.  And if carry is set, we need to add it to $d0.
		sta CHAR_BYTE_ADDRESS + 1 	//store the char rom msb


		//setup the starting screen memory locations.
		lda SCREEN_LSB, x 	//load in the lsb starting screen/colour location for the character to process
		sta $d1				//store screen lsb in zp (we will use Indirect,Y loading later)
		sta $f3 			//store colour lsb in zp (we will use Indirect,Y loading later)
		adc #$29			//add $29 to get the shadow lsb // no CLC needed because the previous ADC has cleared the carry if it was set.
		sta SHADOW + 0		//store shadow lsb at label SHADOW + 0

		ldx #$06			//intizialize the x register with 0 - this will count which byte, of the char, we are processing (6 down to 0)

		KEEP_LOADING:
			asl $01 	//make char rom visible to CPU

			lda CHAR_BYTE_ADDRESS:$BEEF,x  	//load in bitmap byte value of the character // start with row 6, then 5,4,3,2,1,0 (we skip row 7 as it is empty)
			asl 							//asl here to get rid of the left most bit as it is always empty. (saves not having to do the inner loop for it and waste cycles)
			
			lsr $01		//restore the char rom

			ldy OFFSET, x 		//set y to the offset value for the byte/row we are processing
			
			SHIFT: 					//Here process the byte. For any bits set we need to draw to the screen.
				iny					//increment the offset ..... we increment here so flags set by the ASL below are not stomped
				asl 				//asl the accumulator.  If a bit is shifted into the carry, we will draw to the screen.
				bcc !+ 				//skip if the carry is clear / nothing to draw
					pha 				//push 'a' onto the stack as it will get stomped
					lda #$a0 			//screen code for 'inverse space'
					sta ($d1), y 		//store in screen memory location
					sta SHADOW:$05AA, y //store in shadow memory location
					.byte $f3, $f3 		//illegal time!! [ISC (d),Y ($F3 dd; 8 cycles)]  Equivalent to INC value then SBC value.  Replaces the two commented out lines below.  Same number of cycles, but 1 byte smaller.
					//rol 				//'a' is currently $a0. %10100000. And the carry is set.  ROL and 'a' becomes $41. $01000001. But $d800 colour space memory will only use the lower nibble.  So only $01 will be stored.
					//sta ($f3), y 		//store in colour memory location
					pla 				//pull 'a' from the stack so we can keep ASL'ing if needed
				!:
			bne SHIFT 				//if the ASL has shifted all the bits out, the Z flag will be set. (we are done processing the byte)
			dex 					//decrement the row number we are processing for a char
		bpl KEEP_LOADING            //if we have not processed all 7 rows (6 to 0), then branch.
		ldx $40				//restore x value
		dex 				//decrement the char number we are process (2,1,0)
	bpl LOAD_NEXT_CHAR 		//if x is still positve we have another character to process, so branch back up and do it all again.
	rts			 			//we are done!

SCREEN_LSB:
.byte $69, $73, $7d	//Starting lsb addresses for each character

OFFSET:
.byte $ff, $27, $4f, $77, $9f, $c7, $ef  //offsets neeed for each row of a character from that characters starting lsb point
