
// length of the row/column spiral segment being drawn
// the locations for these need to be 39 bytes apart
.label row_length     = $3d 
.label column_length  = $64 //needs to start as $19 (25)

// dir is used to switch between addition and subtraction
// toggles between $ff and $00, initial value needs to be $ff
.label dir           = $0d  


// overwrite the stack to start the program
* = $01F8
.word start - 1  

start:
	// clear the screen
	jsr $E544

	// row length starts at 40 + 2
	ldx #42
	stx row_length

start_spiral_segment:
	// x toggles between 1 and 40, tho its initial value is 42
	// want y and a to toggle between $0 and $ff at the start of each segment
	txa
	and #01
	tay
	dey
	tya

	// want dir to toggle between 0 and ff every 2nd segment
	// (reverse screen drawing direction when a row segment starts)
	eor dir
	sta dir
	
	// toggle x between 1 (for drawing rows) and 40 (for drawing columns)
	// x is value added or subtracted to position in screen memory
	// $d5 initial value is 39
	// $d5 + $ff initial value is 0
	ldx $d5,y
	inx
	
load_segment_length:
	// decrease the column or row segment length by 2 then store in y
	// column length and row length are seperated by 39 bytes
	// so use x to switch between them
	dec $3c,x
	dec $3c,x
	ldy $3c,x

	
	// if the next segment length is negative, loop forever (reached end)
loop_forever:	
	bmi loop_forever  

// start of the loop to draw the segment to the screen	
draw_segment_loop:
	// x has the value to add/subtract (1 or 40)
	// temp is ff or 00 depending on direction
	txa
	eor dir
	
	// set the carry bit according to 7th bit of a without affecting a
	anc #$ff

	// update the address the char will be drawn to
	adc draw_char + 1
	sta draw_char + 1
	lda dir
	adc draw_char + 2
	sta draw_char + 2

load_char:
	lda #$80
draw_char:	
	// start drawing the spiral at $3fe
	sta $3fe
	// y has length remaining of segment to draw
	dey 
	bpl draw_segment_loop

	bmi start_spiral_segment
