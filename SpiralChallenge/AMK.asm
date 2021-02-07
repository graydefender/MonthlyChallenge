/*

	Turtles all the way down
	(c) AMK Enterprises 2021
	All rights reserved 

*/

	// for PC
	.const directionTableHigh = $0114	// would you believe it this memory block is $00,$00,$ff,$ff
										// just what i need for the table! Winner Winner turtle dinner

	// for mac
	//.const directionTableHigh = $017e	// would you believe it this memory block is $00,$00,$ff,$ff
										// just what i need for the table! Winner Winner turtle dinner

	.const theCount = $16				// HA HA HAR
* = $42

Entry:
	jsr $e544							// kernal cls

!outerLoop:

	inx  
	xaa #$03   

	tax 	

	clc
	lda.z <stepz__ , x			// lda stepz__,x 
	adc theCount						// HA HA HAR
	tay

!loop:

/*

	move the cursor to the next point

*/

	clc									

	lda.z <cursor					//	lda cursor
	adc.z <directionTableLow, x		//	adc directionTableLow,x
	sta.z <cursor					//	sta cursor

	lda.z (<cursor)+1				//	lda cursor+1
	adc directionTableHigh, x
	sta.z (<cursor)+1				//	sta cursor+1

/*

	draw an inverse @

*/

	lda #$80							// inverse @ code
	sta cursor:$3fe						// dirty dirty dirty self mod code

/*

	decrease counter
	and
	loop
*/

	dey 
	bne !loop-			

/*

	reduce the length of the line

*/
	dec.z <theCount					//	dec theCount - HA HA HAR

/*

	if line length isnt zero do it all again

*/

	bne !outerLoop-

/*

	stay a while
	.....
 	stay for ever
*/
	beq  *								

stepz__:
	.byte 16,0,16,0

directionTableLow:   
	.byte -1,-40,1,40

* = * "jump"
	bne Entry			
