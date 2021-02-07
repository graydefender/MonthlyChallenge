*=$01f8
.word Spiral-1
.byte $0f // Initial value of "lineAdder" pushed to stack
Spiral:
  
.label scrYoffset = $fe
.label scrL = $52
.label scrH = $53
.label lineLen = $d5
.label lineCount = $16
.label lineAdder = $f0
.label DrawDir = $10

      jsr $e544
MainL:
      ldx lineLen
      inx
!:
      lda #128

      ldy #scrYoffset
      sta (scrL),y

      ldy DrawDir
      clc
      lda scrL          // calc next screen address
      adc offsetsL,y
      sta scrL
      lda scrH
      adc offsetsH,y
      sta scrH

      dex
      bpl !-             // branch if more chars to output for the line

      pla
      eor #$e0 // alternate between $ef and $0f 
      pha

      clc
      adc lineLen // calculate line length
      sta lineLen

      
      iny 
      tya
      and #3
      sta DrawDir // determine next offset adder 1, 40, -1, -40, i.e. which "state" direction are we drawing (right,down,left,up)
      
      dec lineCount    // dec line count
      bpl MainL   // branch if still more lines to draw
      bmi *       // done. infinite loop

offsetsL:
.byte 1,40,-1,-40 // right,down,left,up addition values
.label offsetsH  = $1050 // make use of VICE memory initialisation values for 4 byte patten of 00,00,ff,ff - Yep dirty as :)
      