; ********************************************
; * "C64 Big CHars" - May 2021 SHallan Compo *
; * All code by Geehaf 2021                   *
; ********************************************

* = $c000
      
      ldx #2            ; We are goin gto print 3 big chars
MainLoop:
      stx $b1
      lda scr1,x        ; grab low bye of screen starting address
      sta s1+1
      sta s3+1
      clc
      adc #41
      sta s2+1
      lda $02,x         ; get the char to print
DrawBigChar:
      ldy #$d0
      asl               ; Multiply char to print by 8 (need to consider high byte too), e.g. $21 * 8 = 264
      asl
      asl
      sta $f2
      bcc +             ; if carry clear means number was < #32, i.e. bit 5 was NOT set
      iny
+
      sty $f3
      ldx #$f7
GetChrRomRow:
      lda #$33          ;Switch in ROM for chars
      sta $01
      ldy #6            ; Only need 7 lines from a char
      lda ($f2),y       ; get ROM charset byte (row of 8 bits)
      sta $c0
      asl $01           ; save two bytes not having to do lda #$35 / sta $01 and still 5 cycles in total!
      lda #160          ; Solid block char
DoNextBit:
      lsr $c0
      bcc BitClear      ; Branch if bit NOT set, i.e. no need to draw block char
s1:
      sta $0568,x
s2:
      sta $0568+40+1,x
s3:
      inc $d968,x
BitClear:
      dex
      dey
      bpl DoNextBit
      dec $f2
      txa
      sec
      sbc #33
      tax
      bcs GetChrRomRow
      ldx $b1
      dex
      bpl MainLoop       ; Branch if we have not done 3 characters to print
      rts
scr1:
!BYTE $68,$72,$7c
