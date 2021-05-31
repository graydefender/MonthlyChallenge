PARAM1 = $05
PARAM2 = $06

;we update bottom up
TARGET_SCREEN_ADDRESS = $568 + 6 * 40

* = $c000
          ldx #2
          stx PARAM2

.NextChar          
          ;calc offset in CHAR ROM
          lda $02,x
          asl
          asl
          asl
          sta .ReadPos
          
          ;carry now shows whether 
          ;(yay, char data has only offset hi of 0 or 1)
          ;y is always $ff here
          tya
          adc #$d0 + 1
          sta .ReadPos + 1
          

          ;init screen/color start addresses
          lda SCREEN_START_ADDRESS_LO,x
          sta .WritePos1
          sta .WritePos2
          clc
          adc #41
          sta .WritePos1b
          ;hi starts as $05
          inc .WritePos1 + 1
          inc .WritePos1b + 1
          ;hi starts as $d9
          inc .WritePos2 + 1
          
          ;only need the first 7 lines
          ldy #6
          
.NextLine
          ;we need charrom (and it needs to match lsr/asl to toggle I/O vs. char ROM)
          asl $01

.ReadPos = * + 1
          lda $ffff,y
          sta PARAM1
          
          ;enable I/O for color RAM (for inc to work)
          lsr $01
          
          ;only need the right most 7 pixels
          ldx #6
          lda #160
-          
          ;move right most bit into carry
          lsr PARAM1
          bcc +
          
          ;set block
.WritePos1 = * + 1          
          sta TARGET_SCREEN_ADDRESS - 6 * 40,x
          
          ;shadow block
.WritePos1b = * + 1          
          sta TARGET_SCREEN_ADDRESS - 6 * 40 + 41,x
          
          ;color
.WritePos2 = * + 1
          inc TARGET_SCREEN_ADDRESS - 6 * 40 - $0400 + $d800,x
+         
          dex
          bpl -
          
          ;ugh - next line
          lda .WritePos1
          sec
          sbc #40
          sta .WritePos1
          sta .WritePos2
          bcs +
          dec .WritePos1 + 1
          dec .WritePos2 + 1
+          
          lda .WritePos1b
          sec
          sbc #40
          sta .WritePos1b
          bcs +
          dec .WritePos1b + 1
+          
          
          dey
          bpl .NextLine
          
          dec PARAM2
          ldx PARAM2
          bpl .NextChar
          
          rts      
          
 
          
SCREEN_START_ADDRESS_LO
          !byte <( TARGET_SCREEN_ADDRESS + 1 )
          !byte <( TARGET_SCREEN_ADDRESS + 11 )
          !byte <( TARGET_SCREEN_ADDRESS + 21 )
          
CODE_SIZE = * - $c000

!message "Code Size is ",CODE_SIZE, " bytes"          