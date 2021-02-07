* = $01F8
          // overwrite stack
          .word Start - 1

Start:          
          //clear screen
          jsr $E544
          
!b3:         
          ldx #3

!b2:         
          lda DELTA_LEN,x
          tay
          sec
          sbc #4
          sta DELTA_LEN,x
          
!b1:         
          lda #128
 
          sta DrawPos:$0400 - 2
          
          //inc pos
          lda DELTA_LO,x
          clc
          adc DrawPos
          sta DrawPos
          lda DELTA_HI,x
          adc DrawPos + 1
          sta DrawPos + 1
          
          dey
EndlessLoop:        
          bmi EndlessLoop
          bne !b1-
          
          dex
          bpl !b2-
          bmi !b3-
          
 
DELTA_LO:
          .byte -40, -1, 40, 1
         
          //ROM has $ff,$ff,$00,$00
.label DELTA_HI = $ecb7
          //.byte 255,255,0,0
          
DELTA_LEN:
          .byte 22,39,24,41
  
