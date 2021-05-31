// OldSkoolCoders 8th Attempt at getting below 5k Cycles ;)
// Writtern By OldSkoolCoder (c) 2021

// For the @shallam50k Coding Monthly Compo May 2021.

* = $10 "Storage" virtual

ScreenLocation: .word 0
ShadowLocation: .word 0
ColourLocation: .word 0
CharMemLocation: .word 0

.label Char1ScrnLocation = $0568
.label Char2ScrnLocation = $0572
.label Char3ScrnLocation = $057C

.label Char1ShdowScrnLocation = Char1ScrnLocation + 41
.label Char2ShdowScrnLocation = Char2ScrnLocation + 41
.label Char3ShdowScrnLocation = Char3ScrnLocation + 41

* = $c000 "OldSkoolCoders Code"
	// lda $02
	// sta $0400
	// lda $03
	// sta $0401
	// lda $04
	// sta $0402

	// Start with 3rd Character and work backwards
	lda $04						// Character To Display
	ldx #<Char3ScrnLocation		// Lo Byte Of Screen Location
	jsr GrabAndDisplayChar		// Do it

	lda $03
	ldx #<Char2ScrnLocation
	jsr GrabAndDisplayChar

	lda $02
	ldx #<Char1ScrnLocation
	jsr GrabAndDisplayChar
	rts	

// Acc = Character
// X = Screen Lo Byte
GrabAndDisplayChar:
	asl						// Lo Byte x 2
	asl						// Lo Byte x 4
	asl						// Lo Byte x 8
	sta CharMemLocation		// Store away

	lda #0					// Init
	adc #$D0				// Add Hi Byte, and possible carry
	sta CharMemLocation + 1	// Store away

	lda #$31				// Bank In Char ROM
	sta $01

	ldy #6					// Start at Bottom Of Char
LoopCharacter:
	lda (CharMemLocation),y	// Load
	pha						// Push To Temp Storage
	dey						// Dec Y
	bpl LoopCharacter		// Still a positive Number eh?

	lda #$35				// Bank Out Char ROM
	sta $01

	stx ScreenLocation		// Store Lo Byte Of Screen Position
	stx ColourLocation		// Store Lo Byute Of Colour Position
	txa
	clc
	adc #41					// Add 41 to Screen Position to Give Shadown Position
	sta ShadowLocation		// Store It
	ldy #5					// Load Hi Byte of Screen Position
	sty ScreenLocation + 1	// Store Screen Var
	sty ShadowLocation + 1	// Store Colour Var
	ldy #$D9				// Load Colour Hi Byte
	sty ColourLocation + 1	// Store It

	ldx #6					// Start the Char Row counter 6 (7 incl 0) Bottom Row always 0
CharacterByteLooper:
	ldy #7					// Start @ bit 0
	pla						// Retrieve Char (8th Row was put on first, so last off)

	beq GotoNextByte		// is the byte Zero, If So Bypass

CharacterRowLooper:
	lsr						// Shift Most Sig Bit to Carry
	bcc DontPlaceAnything	// Is the Carry Clear, then ByPass

	pha						// Push Back To Storage
	lda #160				// Load Solid Block
	sta (ShadowLocation),y	// Store On Shadow Location
	sta (ScreenLocation),y	// Store On Screen Location
	lda #WHITE				// Load White
	sta (ColourLocation),y	// Store In Screen Colour Location
	pla						// Retreieve Char From Temp Storage

DontPlaceAnything:
	dey						// Decrease Bit Counter
	bne CharacterRowLooper	// Not Zero yet, so Next Bit Please
GotoNextByte:
	clc						// End Of Row, work out Next Row Positions
	lda ScreenLocation
	adc #40
	sta ScreenLocation
	sta ColourLocation
	bcc !ByPass+
	inc ScreenLocation + 1
	inc ColourLocation + 1
!ByPass:
	clc						// Work Out Next Shadow Row Position
	adc #41
	sta ShadowLocation
	bcc !ByPass+
	inc ShadowLocation + 1

!ByPass:
	dex						// Decrease Char Byte Counter
	bpl CharacterByteLooper	// Still Positive, then back to do next byte.
	rts						// Done


