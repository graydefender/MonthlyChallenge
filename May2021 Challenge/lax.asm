// Attempt at Shalla's May 2021 "Big Chars" challenge, by lax

.label rowIt = $09
.label chIndex = $07
.label charAddr = $16 // +$17

* = $c000
		ldx #2
ch_l:
		stx chIndex

		lda $02, x
		asl
		asl
		asl
		sta charAddr+0
		lda #$68 // $d0>>1
		rol
		sta charAddr+1

		lda offsets, x
		sta pixelAddr+0
		sta colorAddr+0
		adc #41
		sta shadowAddr+0

		lax #0
		tay
row_l:
		sty rowIt

		rol $01
		lda (charAddr), y
		ror $01

		asl
bit_l:
		bpl bit_e

		tay

		lda #1
		sta colorAddr:$d968, x

		lda #160
		sta pixelAddr:$0568, x
		sta shadowAddr:$0568, x

		tya
bit_e:
		inx
		asl
		bne bit_l

row_e:
		ldy rowIt
		iny

		txa
		adc #39
		and #$f8
		tax
		bcc row_l

ch_e:	ldx chIndex
		dex
		bpl ch_l

		rts

offsets:
	.byte $68+1, $72+1, $7c+1
