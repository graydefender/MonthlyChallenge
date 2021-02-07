*=$1000

.const tempx = $fa
.const tempy = $fb
.const cnt   = $fc
.const index = $fd
.const once  = $3a  // Picked was $ff by default
.const Loops = $fe

         *= $1000
         lda #6
         sta Loops

!:		 jsr @Down
 		 inc once
 		 bne @lf
 		 jsr @Insert
@lf:	 jsr @Left
	     lda once
         bne @sk2
         inc left
@sk2:
		 jsr @Up
		 jsr @Right
		 dec Loops
		 bne !-
		 rts
@Right:
		ldy #0
 		sty $7e7
		.byte $2c	
@Down:   
       ldy #[down-right]       
		.byte $2c
@Insert:	 
       ldy #[insert-right]
	  	.byte $2c
@Left:
       ldy #[left-right]
	  .byte $2c
@Up:
       ldy #[up-right]
@InsOpt:		
	   lda right,y
       tax
       sec
       sbc #$4
       sta right,y       
       iny
       sty yy
       
lp:    ldy yy: #$ff
	   
lp1:   lda right,y
	   beq @rtn
       sty tempy
       ldy index
@drw:  sta DrawScreen,y
       ldy tempy
       iny
       inc index     
       bne lp1
@rtn:  
	   sta $400,x
	   dex
	   bpl lp	  
	   ldy index
	   lda #0
	   sta index		
	   sta DrawScreen,y
	   lda #<DrawScreen
	   ldy #>DrawScreen
	   jmp $ab1e	  

right: 
 .byte 37,$40,0
down:
.byte 23,$11,$9d,$40,0
insert:
.byte 0,$9d,$11,0
left:
.byte 38,$9d,$40,$9d,0
up:
.byte 21,$91,$40,$9d,0

*=* "Draw"
DrawScreen:
