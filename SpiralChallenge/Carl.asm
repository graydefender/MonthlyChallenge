* = $46


   // x is $ff at entry, loops back to entry point every line
	!outerLoop:

        	dex // decrement the row # here to make row loop work without extra cpx
        	ldy #-20 // y is horizontal position, leftmost = -20, rightmost = +19
        !loop:
            // first iteration y starts with 1, so there are 19 bytes to ignore
            txa
            adc #14    // compensate for initial x value
                   
                bpl !+
                eor #$ff
            !:
	            adc #8    // largest x=20, so add 8 to y, largest y = 12
	            bmi *    // when row = $78 the adc will set the N flag so loop infinitely when done
	            sta 2    // store off the positive distance from center
	            tya
            
                bpl !+
                eor #$ff
            !:
            
                cmp 2
                bcs !+
                txa
            
            !:
                lsr
                lda #$20
                bcc !+
                asl
                asl
            !:
            
                sta drawpos:$400-40*1-19    // adjust 1 row up + y start value 
                inc drawpos
                bne !+
                inc drawpos+1
            !:
           
            iny
            cpy #20
            
            bne !loop-    // <- autostarts here with Z clear (address $73)
      
        beq !outerLoop-    // loop each row
    


